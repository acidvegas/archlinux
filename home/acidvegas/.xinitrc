#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

xset +fp /usr/share/fonts/local
xset fp rehash
xset s 3600 3600

slstatus &
unclutter &

exec dwm