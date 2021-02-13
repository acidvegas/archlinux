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

# rewrites
alias exa='exa -aghl --git'
alias mtm='mtm -t mtm-256color'
alias ssh-add='ssh-add -t 1h'
alias su='su -l'

# random
alias ..='cd ../'
alias busy="cat /dev/urandom | hexdump -C | grep 'ca fe'"
alias dump='setterm -dump 1 -file screen.dump'
alias pinstall='pip install --user'
alias pubkey='ssh-keygen -y -f ~/.ssh/key'
alias pydebug='python -m trace -t'
alias y2m='youtube-dl --extract-audio --audio-format mp3 --audio-quality 0  -o "%(title)s.%(ext)s" --no-cache-dir --no-call-home'

# scripts
alias pipes='sh $HOME/dev/build/pipes/pipes.sh'
alias todo='~/.scripts/todo'

color() {
	for color in {0..255}; do
		printf "\e[48;5;%sm  %3s  \e[0m" $color $color
		if [ $((($color + 1) % 6)) == 4 ]; then
			echo
		fi
	done
}

rnd() {
	cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $1 | head -n 1
}

title() {
	echo -ne "\033]0;$1\007"
}

transfer() {
	TMP=$(mktemp -t transferXXX)
	curl -H "Max-Downloads: 1" -H "Max-Days: 1" --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $TMP
	cat $TMP
	rm -f $TMP
}

update() {
	sudo pacman-key --refresh-keys
	sudo mount -o remount,rw /boot && sudo pacman -Syyu && sudo mount -o remount,ro /boot
	sudo pacman -Rns $(pacman -Qtdq)
	sudo pacman -Scc
	for d in $(find $HOME/dev/git/mirrors -type d -name .git); do
		cd $(dirname $d) && git pull
	done;
}

export PS1="\e[38;5;237m\T\e[0m \e[38;5;41m\u@\h\e[0m \e[38;5;69m\w \e[0m: "