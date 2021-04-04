static const unsigned int borderpx = 0;
static const unsigned int snap     = 32;
static const int showbar           = 0;
static const int topbar            = 1;
static const float mfact           = 0.55;
static const int nmaster           = 1;
static const int resizehints       = 0;
static const Layout layouts[]      = { { "", tile } };
static const Rule rules[]          = { { NULL, NULL, NULL, 0, False, -1 } };
static const char *tags[]          = { "dev", "irc", "music", "www", "other" };
static const char *fonts[]         = { "Misc Ohsnap.Icons:style=Regular:size=11" };
static const char dmenufont[]      = "Misc Ohsnap.Icons:style=Regular:size=11";
static const char *colors[][3]     = {
	[SchemeNorm]   = { "#FFFFFF", "#000000", "#444444" },
	[SchemeSel]    = { "#00D787", "#000000", "#00D787" },
};

#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY, view,       {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY, toggleview, {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY, tag,        {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY, toggletag,  {.ui = 1 << TAG} },

// todo: pmenu/todo
static const char *dmenucmd[]   = { "dmenu_run", "-m", "0", "-fn", dmenufont, "-nb", "#000000", "-nf", "#FFFFFF", "-sb", "#000000", "-sf", "#00D787", NULL };
static const char *termcmd[]    = { "tabbed", "-cf", "st", "-w", NULL };
static const char *mutevol[]    = { "amixer", "-q", "set", "Headphone", "toggle", NULL };
static const char *downvol[]    = { "amixer", "-q", "set", "Headphone", "5-",     NULL };
static const char *upvol[]      = { "amixer", "-q", "set", "Headphone", "5+",     NULL };
static const char *musprev[]    = { "cmus-remote", "-r", NULL };
static const char *mustoggle[]  = { "cmus-remote", "-u", NULL };
static const char *musnext[]    = { "cmus-remote", "-n", NULL };

static Key keys[] = {
	{ MODKEY, XK_Return, spawn,      {.v = termcmd } },
	{ MODKEY, XK_Down,   incnmaster, {.i = +1 } },
	{ MODKEY, XK_Up,     incnmaster, {.i = -1 } },
	{ MODKEY, XK_Left,   setmfact,   {.f = -0.05} },
	{ MODKEY, XK_Right,  setmfact,   {.f = +0.05} },
	{ MODKEY, XK_h,      togglebar,  {0} },
	{ MODKEY, XK_k,      killclient, {0} },
	{ MODKEY, XK_q,      quit,       {0} },
	{ MODKEY, XK_f,      setlayout,  {.v = &layouts[0]} },
	{ MODKEY, XK_r,      spawn,      {.v = dmenucmd } },
	{ MODKEY, XK_F2,     spawn,      {.v = downvol } },
	{ MODKEY, XK_F3,     spawn,      {.v = upvol } },
	{ MODKEY, XK_F4,     spawn,      {.v = mutevol } },
	{ MODKEY, XK_F6,     spawn,      {.v = musprev } },
	{ MODKEY, XK_F7,     spawn,      {.v = mustoggle } },
	{ MODKEY, XK_F8,     spawn,      {.v = musnext } },
	TAGKEYS(  XK_1, 0)
	TAGKEYS(  XK_2, 1)
	TAGKEYS(  XK_3, 2)
	TAGKEYS(  XK_4, 3)
	TAGKEYS(  XK_5, 4)
};

static Button buttons[] = {
	{ ClkWinTitle,  0,      Button2, zoom,        {0} },
	{ ClkClientWin, MODKEY, Button1, movemouse,   {0} },
	{ ClkClientWin, MODKEY, Button3, resizemouse, {0} },
	{ ClkTagBar,    0,      Button1, view,        {0} },
	{ ClkTagBar,    MODKEY, Button1, tag,         {0} },
};