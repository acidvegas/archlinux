#!/bin/sh
set -xev

GIT_URL="https://raw.githubusercontent.com/acidvegas/archlinux/master"

setup_configs() {
	wget -O $HOME/.bashrc $GIT_URL/home/acidvegas/.bashrc
	echo "[[ -f ~/.bashrc ]] && . ~/.bashrc" > $HOME/.bash_profile
	mkdir -p $HOME/.config/cmus && wget -O $HOME/.config/cmus/autosave $GIT_URL/home/acidvegas/.config/cmus/autosave
	mkdir $HOME/.config/dunst && wget -O $HOME/.config/dunst/dunstrc $GIT_URL/home/acidvegas/.config/dunst/dunstrc
	echo "* -crlf" > $HOME/.gitattributes
	wget -O $HOME/.gitconfig $GIT_URL/home/acidvegas/.gitconfig
	mkdir $HOME/.gnupg && wget -O $HOME/.gnupg/gpg.conf $GIT_URL/home/acidvegas/.gnupg/gpg.conf &&	chmod 700 $HOME/.gnupg && echo -e "pinentry-program /usr/bin/pinentry-curses\ndefault-cache-ttl 3600" > $HOME/.gnupg/gpg-agent.conf && chmod 600 $HOME/.gnupg/*
	mkdir $HOME/.ssh && touch $HOME/.ssh/config && chown -R $USER $HOME/.ssh && chmod 700 $HOME/.ssh && chmod 600 $HOME/.ssh/config
	wget -O $HOME/.xinitrc $GIT_URL/home/acidvegas/.xinitrc
	echo -e "#!/bin/sh\nexec /usr/bin/Xorg -nolisten tcp -nolisten local \"$@\" vt$XDG_VTNR" > $HOME/.xserverrc
	source $HOME/.bashrc
}

setup_pypi() {
	pip install --user lyricsgenius # finish adding these
}

setup_builds() { # aur vs git?
	mkdir -p $HOME/dev/git/mirror

	git clone https://github.com/miguelmota/cointop.git $HOME/dev/git/mirror/cointop
	cd $HOME/dev/git/mirror/cointop && makepkg -si # change this to build dir

	git clone https://github.com/jarun/ddgr.git $HOME/dev/git/mirror/ddgr
	sudo make -C $HOME/dev/git/mirror/ddgr clean install

	git clone http://git.suckless.org/dwm $HOME/dev/git/mirror/dwm
	wget -O $HOME/dev/git/mirror/dwm/config.h $GIT_URL/home/acidvegas/dev/git/mirror/dwm/config.h
	wget -O $HOME/dev/git/mirror/dwm/patch_nosquares.diff $GIT_URL/home/acidvegas/dev/git/mirror/dwm/patch_nosquares.diff
	wget -O $HOME/dev/git/mirror/dwm/patch_notitles.diff $GIT_URL/home/acidvegas/dev/git/mirror/dwm/patch_notitles.diff
	patch $HOME/dev/git/mirror/dwm/drw.c $HOME/dev/git/mirror/dwm/patch_nosquares.diff
	patch $HOME/dev/git/mirror/dwm/dwm.c $HOME/dev/git/mirror/patch_notitles.diff
	sudo make -C $HOME/dev/git/mirror/dwm clean install

	git clone https://github.com/jarun/googler.git $HOME/dev/git/mirror/googler
	sudo make -C $HOME/dev/git/mirror/googler clean install

	git clone https://github.com/deadpixi/mtm.git $HOME/dev/git/mirror/mtm
	sed -i 's/!defined(__linux__)/!defined(__linux__) || !defined(linux)/' $HOME/dev/git/mirror/mtm/config.def.h # missing ncurses fix
	sudo make -C $HOME/dev/git/mirror/mtm clean install

	git clone --depth 1 https://aur.archlinux.org/ohsnap.git $HOME/dev/git/mirror/ohsnap
	cd $HOME/dev/git/mirror/ohsnap && makepkg -si # find a way to this without cd

	git clone https://github.com/pipeseroni/pipes.sh.git $HOME/dev/git/mirror/pipes
	sudo make -C $HOME/dev/git/mirror/pipes

	git clone --depth 1 git://git.suckless.org/slstatus $HOME/dev/git/mirror/slstatus
	wget -O $HOME/dev/git/mirror/slstatus/config.h $GIT_URL/home/acidvegas/dev/git/mirror/slstatus/config.h
	sudo make -C $HOME/dev/git/mirror/slstatus clean install

	git clone --depth 1 git://git.suckless.org/st $HOME/dev/git/mirror/st
	wget -O $HOME/dev/git/mirror/st/config.h $GIT_URL/home/acidvegas/dev/git/mirror/st/config.h
	sed -i 's/it#8,/it#4,/g' $HOME/dev/git/mirror/st/st.info
	sudo make -C $HOME/dev/git/mirror/st clean install

	git clone --depth 1 git://git.suckless.org/tabbed $HOME/dev/git/mirror/tabbed
	wget -O $HOME/dev/git/mirror/tabbed/config.h $GIT_URL/home/acidvegas/dev/git/mirror/tabbed/config.h
	wget -O $HOME/dev/git/mirror/tabbed/patch_autohide.diff $GIT_URL/home/acidvegas/dev/git/mirror/tabbed/patch_autohide.diff
	wget -O $HOME/dev/git/mirror/tabbed/patch_clientnumber.diff $GIT_URL/home/acidvegas/dev/git/mirror/tabbed/patch_clientnumber.diff
	patch $HOME/dev/git/mirror/tabbed/tabbed.c $HOME/dev/git/mirror/tabbed/patch_autohide.diff
	patch $HOME/dev/git/mirror/tabbed/tabbed.c $HOME/dev/git/mirror/tabbed/patch_clientnumber.diff
	sudo make -C $HOME/dev/git/mirror/tabbed clean install

	mkdir $HOME/.scripts
	for SCRIPT in cmus-now lyrics.py mutag todo; do
		wget -O $HOME/.scripts/$SCRIPT $GIT_URL/home/acidvegas/.scripts/$SCRIPT && chmod +x $HOME/.scripts/$SCRIPT
	done

	mkdir -p $HOME/.local/share/fonts && wget -O $HOME/.local/share/fonts/BlockZone.ttf https://github.com/ansilove/BlockZone/raw/master/BlockZone.ttf
}

setup_configs
setup_builds