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
	echo -e "#!/bin/sh\nexec /usr/bin/Xorg -nolisten tcp -nolisten local \"$@\" vt$XDG_VTNR" > $HOME/.xserverrc # check this
	source $HOME/.bashrc
}

setup_pypi() {
	pip install --user lyricsgenius # finish adding these
}

setup_builds() { # aur or git?
	mkdir -p $HOME/dev/build
	mkdir -p $HOME/dev/git/mirror

	git clone https://github.com/miguelmota/cointop.git $HOME/dev/git/mirror/cointop # make install
	cd $HOME/dev/git/mirror/cointop && makepkg -si # change this to build dir

	git clone https://github.com/jarun/ddgr.git $HOME/dev/git/mirror/ddgr

	git clone http://git.suckless.org/dwm $HOME/dev/git/mirror/dwm
	cp -r $HOME/dev/git/mirror/dwm $HOME/dev/build/dwm && rm -rf $HOME/dev/build/dwm/.git # check
	wget -O $HOME/dev/build/dwm/config.h $GIT_URL/home/acidvegas/dev/build/dwm/config.h
	wget -O $HOME/dev/build/dwm/patch_nosquares.diff $GIT_URL/home/acidvegas/dev/build/dwm/patch_nosquares.diff
	wget -O $HOME/dev/build/dwm/patch_notitles.diff $GIT_URL/home/acidvegas/dev/build/dwm/patch_notitles.diff
	cd $HOME/dev/build/dwm && patch drw.c patch_nosquares.diff && patch dwm.c patch_notitles.diff && rm $HOME/dev/build/dwm/*.diff
	sudo make -C $HOME/dev/build/dwm clean install

	git clone https://github.com/jarun/googler.git $HOME/dev/build/googler

	git clone https://github.com/deadpixi/mtm.git $HOME/dev/git/mirror/mtm
	cp -r $HOME/dev/git/mirror/mtm $HOME/dev/build/mtm
	sed -i 's/!defined(__linux__)/!defined(__linux__) || !defined(linux)/' $HOME/dev/build/mtm/config.def.h # missing ncurses fix
	sudo make -C $HOME/dev/build/mtm clean install

	git clone --depth 1 https://aur.archlinux.org/ohsnap.git $HOME/dev/build/ohsnap
	cd $HOME/dev/build/ohsnap && makepkg -si

	git clone https://github.com/pipeseroni/pipes.sh.git $HOME/dev/git/mirror/pipes

	git clone --depth 1 git://git.suckless.org/slstatus $HOME/dev/build/slstatus
	wget -O $HOME/dev/build/slstatus/config.h $GIT_URL/home/acidvegas/dev/build/slstatus/config.h
	sudo make -C $HOME/dev/build/slstatus clean install

	git clone --depth 1 git://git.suckless.org/st $HOME/dev/build/st
	wget -O $HOME/dev/build/st/config.h $GIT_URL/home/acidvegas/dev/build/st/config.h # Changes to font, tab size, and colors
	sed -i 's/it#8,/it#4,/g' $HOME/dev/build/st/st.info
	sudo make -C $HOME/dev/build/st clean install

	git clone --depth 1 git://git.suckless.org/tabbed $HOME/dev/build/tabbed
	wget -O $HOME/dev/build/tabbed/config.h $GIT_URL/home/acidvegas/dev/build/tabbed/config.h
	wget -O $HOME/dev/build/tabbed/patch_autohide.diff $GIT_URL/home/acidvegas/dev/build/tabbed/patch_autohide.diff
	wget -O $HOME/dev/build/tabbed/patch_clientnumber.diff $GIT_URL/home/acidvegas/dev/build/tabbed/patch_clientnumber.diff
	cd $HOME/dev/build/tabbed && patch tabbed.c patch_autohide.diff && patch tabbed.c patch_clientnumber.diff && rm $HOME/dev/build/tabbed/*.diff
	sudo make -C $HOME/dev/build/tabbed clean install

	mkdir $HOME/.scripts
	for SCRIPT in backup cmus-now gitremote lyrics.py mutag todo; do
		wget -O $HOME/.scripts/$SCRIPT $GIT_URL/home/acidvegas/.scripts/$SCRIPT && chmod +x $HOME/.scripts/$SCRIPT
	done

	mkdir -p $HOME/.local/share/fonts && wget -O $HOME/.local/share/fonts/BlockZone.ttf https://github.com/ansilove/BlockZone/raw/master/BlockZone.ttf
}

setup_configs
setup_builds