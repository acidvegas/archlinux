[[ $- != *i* ]] && return

shopt -s checkwinsize

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GPG_TTY=$(tty)

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
	ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
	source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# colors
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'
alias ls='ls --color=auto'
alias ncdu='ncdu --color dark -rr'

# rewrites
alias ddgr='ddgr -n 5 -x --np --colors=nodgiy'
alias exa='exa -aghl --git'
alias google='googler -n 5 -x --np --colors=nodgiy'
alias mtm='mtm -t mtm-256color'
alias pipes='pipes -p 5 -r 0 -f 20'
alias ssh-add='ssh-add -t 1h'
alias su='su -l'
alias vlock='vlock -a'

# random
alias ..='cd ../'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias dump='setterm -dump 1 -file screen.dump'
alias pinstall='pip install --user'
alias pubkey='ssh-keygen -y -f ~/.ssh/key'
alias pydebug='python -m trace -t'
alias tb="(exec 3<>/dev/tcp/termbin.com/9999; cat >&3; cat <&3; exec 3<&-)"
alias weather="curl wttr.in/11955?format=\"%c+%C+%7C+%h+%7C+%t+%28+%f+%29+%w+%7C+%l+%7C+%m+%M+%7C+%p+%P\n\""
alias y2m='youtube-dl --extract-audio --audio-format mp3 --audio-quality 0 -o "%(title)s.%(ext)s" --no-cache-dir --no-call-home'

# scripts
alias lyrics='python $HOME/.scripts/lyrics.py'
alias mutag='sh $HOME/.scripts/mutag'
alias todo='~/.scripts/todo'

backup() {
	mkdir -p $HOME/.backup/tmp && rm -rf $HOME/.backup/tmp/*
	gpg --export-secret-keys --armor acidvegas > $HOME/.backup/tmp/key.gpg
	ssh supernets 'tar -zcvf ~/supernets.tar.gz ~/services ~/unrealircd ~/www /etc/nginx/nginx.conf' && scp supernets:supernets.tar.gz $HOME/.backup/tmp/supernets.tar.gz
	ssh omega 'tar -zcvf ~/bots.tar.gz ~/bots' && scp watchdog:bots.tar.gz $HOME/.backup/tmp/bots.tar.gz
	tar -zcvf $HOME/.backup/backup-$(date +%Y-%m-%d).tar.gz --transform '!^.*/!!' $HOME/.backup/tmp/bots.tar.gz $HOME/.backup/tmp/key.gpg $HOME/.backup/tmp/supernets.tar.gz $HOME/.password-store $HOME/.ssh/config $HOME/.ssh/key $HOME/dev $HOME/doc $HOME/music
	rm -rf $HOME/.backup/tmp
}

clbin() {
	local url=$(cat $1 | curl -sF 'clbin=<-' https://clbin.com)
	echo "$url?<hl>"
}

color() {
	for color in {0..255}; do
		printf "\e[48;5;%sm  %3s  \e[0m" $color $color
		if [ $((($color + 1) % 6)) == 4 ]; then
			echo
		fi
	done
}

gitremote() {
	for d in $(find $HOME/dev/git -type d -name mirrors -prune -o -type d -name .git -print | sort); do
		u=$(echo $d | cut -d/ -f6)
		r=$(echo $d | cut -d/ -f7)
		echo "updating $u/$r..."
		git -C $d remote remove origin
		if [ $r = 'acid.vegas' ]; then
			git -C $d remote add origin git@github.com:$u/acidvegas.github.io.git
			git -C $d remote set-url --add --push origin git@github.com:$u/acidvegas.github.io.git
			git -C $d remote set-url --add --push origin git@gitlab.com:$u/acidvegas.gitlab.io.git
			git -C $d remote set-url --add --push origin git@bird:$r.git
		elif [ $r = 'supernets.org' ]; then
			git -C $d remote add origin git@github.com:$u/supernets.github.io.git
			git -C $d remote set-url --add --push origin git@github.com:$u/supernets.github.io.git
			git -C $d remote set-url --add --push origin git@gitlab.com:$u/supernets.gitlab.io.git
			git -C $d remote set-url --add --push origin git@bird:$r.git
		else
			git -C $d remote add origin git@github.com:$u/$r.git
			git -C $d remote set-url --add --push origin git@github.com:$u/$r.git
			git -C $d remote set-url --add --push origin git@gitlab.com:$u/$r.git
			git -C $d remote set-url --add --push origin git@bird:$r.git
		fi
		git -C $d config user.signingkey 441EB0F297E0DCF0AEF2F711EF4B922DB85DC9DE
	done
}

rnd() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

title() {
	echo -ne "\033]0;$1\007"
}

transfer() {
	local output=$(curl -sD - -H "Max-Downloads: $3" -H "Max-Days: $2" --upload-file "$1" https://transfer.sh/$(basename "$1"))
	local url=$(echo "$output" | tail -n1)
	echo "Link  : $url"
	echo "Direct: $url" | sed "s/transfer\.sh/transfer.sh\/get/"
	echo "Inline: $url" | sed "s/transfer\.sh/transfer.sh\/inline/"
	echo "$output" | sed "s/x-url-delete/Delete/" | grep "Delete"
}

update() {
	sudo pacman-key --refresh-keys
	sudo mount -o remount,rw /boot && sudo pacman -Syyu && sudo mount -o remount,ro /boot
	sudo pacman -Rns $(pacman -Qtdq)
	sudo pacman -Scc
	for d in $(find $HOME/dev/git/mirror -type d -name .git); do
		cd $(dirname $d) && git pull
	done;
	find /etc -regextype posix-extended -regex ".+\.pac(new|save)" 2> /dev/null
	find / -xtype l -print
	systemctl --failed
	journalctl -p 3 -xb
}

export PS1="\e[38;5;237m\T\e[0m \e[38;5;41m\u@\h\e[0m \e[38;5;69m\w \e[0m: "