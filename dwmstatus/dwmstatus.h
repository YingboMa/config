#pragma once

#include <X11/Xlib.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <time.h>

#define _POSIX_C_SOURCE 200809L
#include <stdarg.h>
#include <unistd.h>

#include <alsa/asoundlib.h>
#include <fcntl.h>

#define LIKELY(x) __builtin_expect((x), 1)
#define UNLIKELY(x) __builtin_expect((x), 0)

#define MAXLEN 256

int audio(char* ptr, size_t size);
int date(char*, size_t);
int mem(char*, size_t);
int brightness(char*, size_t);
int temp(char*, size_t);
int weather(char* ptr, size_t size);
int cpu(char*, size_t);
int bat(char*, size_t);
int sep_left(char*, size_t);
int sep_right(char*, size_t);
int XSetRoot(char*);
int alsa_audio_volume(long* outvol);

void readfile(char* path, const char* format, ...);
