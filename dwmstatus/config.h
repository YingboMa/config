#define CPUSTAT "/proc/stat"
#define SYSBAT0 "/sys/class/power_supply/BAT0"
#define SYSBAT1 "/sys/class/power_supply/BAT1"
#define SYSHWMON0 "/sys/devices/virtual/thermal/thermal_zone0/hwmon0"
#define SYSBRIGHT "/sys/class/backlight/intel_backlight/brightness"
#define SYSBRIGHTMAX "/sys/class/backlight/intel_backlight/max_brightness"

//#define BEGINSEPARATOR " "
//#define ENDSEPARATOR " "
#define LEFTSEPARATOR " "
#define RIGHTSEPARATOR " "
#define AUDIOFS "🔊 %ld%%"
#define TIMEFS "📅 %a, %d %b  ⏰ %I:%M%P"
#define RAMFS "💾 %.0fM"
#define BRIGHTFS "🔆 %ld%%"
#define TEMPFS "🌡 %.0lfC"
#define CPUFS "🔥%2.0f%%"
#define BATFS "🔋 %d%%%c"

int (*const functab[])(char*, size_t) = {
    sep_left, weather, //    sep_right, -- already seems to append a space.
    sep_left, audio,      sep_right,
    sep_left, brightness, sep_right,
    sep_left, mem,        sep_right,
    sep_left, cpu,        sep_right,
    sep_left, temp,       sep_right,
    sep_left, bat,        sep_right,
    sep_left, date,       sep_right,
};

int N_funcs = sizeof(functab) / sizeof(functab[0]);
