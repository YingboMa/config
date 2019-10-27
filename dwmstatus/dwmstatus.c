#include "dwmstatus.h"
#include "config.h"
#include <signal.h>

extern int (*const functab[])(char*, size_t);
extern int N_funcs;

static void nothing(const int signo) { (void)signo; }

int sep_left(char* ptr, size_t size) {
  return snprintf(ptr, size, LEFTSEPARATOR);
}

int sep_right(char* ptr, size_t size) {
  return snprintf(ptr, size, RIGHTSEPARATOR);
}

int audio(char* ptr, size_t size) {
  long outvol = 0;
  int retcode = alsa_audio_volume(&outvol);
  if (LIKELY(retcode == 0)) {
    return snprintf(ptr, size, AUDIOFS, outvol);
  } else {
    fprintf(stderr, "alsa_audio_volume exits with code %d\n", retcode);
    return 0;
  }
}

int date(char* ptr, size_t size) {
  time_t now = time(0);
  return strftime(ptr, size, TIMEFS, localtime(&now));
}

int mem(char* ptr, size_t size) {
  struct sysinfo s;
  sysinfo(&s);
  return snprintf(ptr, size, RAMFS, (double)(s.freeram) / (double)(1UL << 20));
}

int brightness(char* ptr, size_t size) {
  double br_cur = 0.;
  double br_max = 0.;
  readfile(SYSBRIGHT, "%lf", &br_cur, sizeof(br_cur));
  readfile(SYSBRIGHTMAX, "%lf", &br_max, sizeof(br_max));
  return snprintf(ptr, size, BRIGHTFS, (long)round(br_cur * 100. / br_max));
}

int temp(char* ptr, size_t size) {
  double temp0;
  readfile(SYSHWMON0 "/temp1_input", "%lf", &temp0, sizeof(temp0));
  return snprintf(ptr, size, TEMPFS, temp0 / 1000);
}

int cpu(char* ptr, size_t size) {
  //                 user,nice,sys,idle
  static size_t a[4] = {0, 0, 0, 0};
  size_t b[4] = {0, 0, 0, 0};

  memcpy(b, a, sizeof(b));
  readfile(CPUSTAT, "cpu  %zu %zu %zu %zu", a + 0, a + 1, a + 2, a + 3);
  double cpu_used = (a[0] + a[1] + a[2]) - (b[0] + b[1] + b[2]);
  double cpu_time = (a[0] + a[1] + a[2] + a[3]) - (b[0] + b[1] + b[2] + b[3]);
  double cpu_usage = cpu_used * 100. / cpu_time;
  return snprintf(ptr, size, CPUFS, cpu_usage);
}

int bat(char* ptr, size_t size) {
  char batstatus = 0;
  int batcapacity = 0;
  if (access(SYSBAT1 "/status", F_OK) != -1) {
    readfile(SYSBAT1 "/status", "%c", &batstatus);
    readfile(SYSBAT1 "/capacity", "%d", &batcapacity);
  } else {
    readfile(SYSBAT0 "/status", "%c", &batstatus);
    readfile(SYSBAT0 "/capacity", "%d", &batcapacity);
  }
  switch (batstatus) {
  case 'C':
    batstatus = '+';
    break;
  case 'D':
    batstatus = '-';
    break;
  case 'U':
    batstatus = '=';
    break;
  default:
    batstatus = 'N';
  }
  return snprintf(ptr, size, BATFS, batcapacity, batstatus);
}

int XSetRoot(char* name) {
  Display* display;

  if (UNLIKELY((display = XOpenDisplay(0x0)) == NULL)) {
    fprintf(stderr, "Cannot open display!\n");
    return -1;
  }

  XStoreName(display, DefaultRootWindow(display), name);
  XSync(display, 0);

  XCloseDisplay(display);
  return 0;
}

void readfile(char* path, const char* format, ...) {
  va_list args;
  va_start(args, format);
  FILE* pf = fopen(path, "r");
  if (LIKELY(pf != NULL)) {
    rewind(pf);
    vfscanf(pf, format, args);
    fclose(pf);
  }
  va_end(args);
  return;
}

int alsa_audio_volume(long* outvol) {
  int ret = 0;
  snd_mixer_t* handle;
  snd_mixer_elem_t* elem;
  snd_mixer_selem_id_t* sid;

  static const char* mix_name = "Master";
  static const char* card = "default";
  static int mix_index = 0;

  snd_mixer_selem_id_alloca(&sid);

  snd_mixer_selem_id_set_index(sid, mix_index);
  snd_mixer_selem_id_set_name(sid, mix_name);

  if ((snd_mixer_open(&handle, 0)) < 0)
    return -1;
  if ((snd_mixer_attach(handle, card)) < 0) {
    snd_mixer_close(handle);
    return -2;
  }
  if ((snd_mixer_selem_register(handle, NULL, NULL)) < 0) {
    snd_mixer_close(handle);
    return -3;
  }
  ret = snd_mixer_load(handle);
  if (ret < 0) {
    snd_mixer_close(handle);
    return -4;
  }
  elem = snd_mixer_find_selem(handle, sid);
  if (!elem) {
    snd_mixer_close(handle);
    return -5;
  }

  long minv, maxv;

  snd_mixer_selem_get_playback_volume_range(elem, &minv, &maxv);
  // fprintf(stderr, "Volume range <%i,%i>\n", minv, maxv);

  if (snd_mixer_selem_get_playback_volume(elem, 0, outvol) < 0) {
    snd_mixer_close(handle);
    return -6;
  }

  // fprintf(stderr, "Get volume %i with status %i\n", *outvol, ret);
  /* make the value bound to 100 */
  *outvol -= minv;
  maxv -= minv;
  minv = 0;
  *outvol = 100 * (*outvol) / maxv; // make the value bound from 0 to 100
  snd_mixer_close(handle);
  return 0;
}

int main(void) {
  struct sigaction noact;
  memset(&noact, 0, sizeof(noact));
  noact.sa_handler = nothing;
  sigaction(SIGUSR1, &noact, NULL);

  static char status[MAXLEN];
  size_t i, currentlen, len;
  int isfirst = 1;
  char* currentptr;
  do {
    isfirst || sleep(5);
    isfirst = 0;
    len = 0;
    for (i = 0; i < N_funcs; ++i) {
      currentptr = status + len;
      currentlen = MAXLEN - len;
      if (UNLIKELY(currentptr >= (status + MAXLEN)))
        break;
      len += functab[i](currentptr, currentlen);
    }
  } while (!XSetRoot(status));
  return 0;
}
