const unsigned int interval = 1000;
static const char unknown_str[] = "??";

#define MAXLEN 2048

static const struct arg args[] = {
	{ cpu_perc,		"Ç %s% | ",  NULL},
	{ ram_perc,		"Æ %s% | ",  NULL},
	{ disk_perc,	"¨ %s% | ",  "/"},
	{ temp,			"± %s°C | ", "/sys/class/thermal/thermal_zone0/temp"},
	{ battery_perc, "ð %s% | ",  "BAT0"},
	{ vol_perc,		"í %s% | ",  "/dev/dsp"},
	{ datetime,		"ú %s",      "%m/%d | · %I:%M" },
};