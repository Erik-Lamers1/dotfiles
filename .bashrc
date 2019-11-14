# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

normal_color=$'\033[00m'
red_color=$'\033[41m'
exit_color=$normal_color

set_exit_color() {
    if [ "$?" != 0 ]; then
        exit_color=$red_color
    else
        exit_color=$normal_color
    fi
}

PROMPT_COMMAND=set_exit_color

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[$exit_color\][$?]\[$normal_color\]"
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w'
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Erik - Custom zooi
function exit_code_color() {
	# Reset to origin
	PS1=$ORIGINAL_PS1
	# Set no color and red
	local RCol='\[\e[0m\]'
	local Red='\[\e[0;31m\]'
	# Check for good exit code
	if [ $? == 0 ]; then
		echo blaap
		# Good exit code gets no color
		PS1+=" ${RCol}[$?] "
	else
		# Bad exit code gets a red color
		PS1+=" ${Red}[$?]${Rcol} "
	fi
}

# To the salt mines
cat ~/.art

# SSH agent werkt niet lekker op 18.04
eval $(ssh-agent)
if [ -S "$SSH_AUTH_SOCK" ]; then
   export `/usr/bin/gnome-keyring-daemon --start`
fi

# Give an exit code
exit_code="$?"


function git-new-branch () {
	branch_name=$1
	git checkout master
	git pull
	git checkout -b $branch_name
}

# Git branch

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM=verbose
export PS1="$PS1 \$(__git_ps1 '(%s)')\$ "


# Export a secret value (password, etc.) to a shell variable.
# The variable name can be passed as the argument, or 'SECRET_VALUE'
# is used by default.
# This helps to avoid typing secrets so they're saved in history,
# or saving them to files that maybe forgotten later to be removed.
#
# Usage:
# $ export_secret_value VARNAME
# (enter the secret/password to the prompt)
# $ echo $VARNAME
#
function export_secret_value {
    local _secret_var_name=${1:-SECRET_VALUE}
    local _secret_var_value=''
    local IFS=$'\n'
    read -s -r _secret_var_value
    echo "$_secret_var_name=$_secret_var_value"
    export "$_secret_var_name=$_secret_var_value"
}

