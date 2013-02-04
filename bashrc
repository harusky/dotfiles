# .bashrc

# Source global definitions
[ -f /etc/bashrc ] && . /etc/bashrc

# Source ARM definitions
[ -e $HOME/.bashrc.arm ] && source $HOME/.bashrc.arm

export LANG=en_US.utf-8
export LC_ALL=en_US.utf-8

# set personal dir colors
eval `dircolors $HOME/.dir_colors`

[ -z "$PS1" ] && return

#------------------------------------------------------------
# SETTINGS
#------------------------------------------------------------

export TERM=xterm-256color

# export MAKEFLAGS='-j3'

export GIT_PS1_SHOWDIRTYSTATE=YES
export GIT_PS1_SHOWSTASHSTATE=YES

# Make Bash append rather than overwrite the history on disk:
shopt -s histappend
export HISTIGNORE="&:ls:[bf]g:exit"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# When changing directory small typos can be ignored by Bash
shopt -s cdspell

# Need ctrl-d twice before exiting
set -o ignoreeof # ctrl-D will not exit the shell anymore
export IGNOREEOF=1

# default file creation permission
# user = all; group = read; others = none
umask 027

# editor for svn, ...
export EDITOR=vim

# for developing: http://udrepper.livejournal.com/11429.html
#export MALLOC_CHECK_=3
#export MALLOC_PERTURB_=$(($RANDOM % 255 + 1))

# Let me have core dumps
#ulimit -c unlimited

#------------------------------------------------------------
# COMPLETION
#------------------------------------------------------------

#[ -e $HOME/etc/bash_completion ] && [ ! -z $BASH_COMPLETION ] && export BASH_COMPLETION=$HOME/etc/bash_completion
#[ -e $HOME/.bash_completion.d ] && [ ! -z $BASH_COMPLETION_DIR ] && export BASH_COMPLETION_DIR=$HOME/.bash_completion.d
#[ ! -z $BASH_COMPLETION ] && source $BASH_COMPLETION
export BASH_COMPLETION=$HOME/etc/bash_completion
export BASH_COMPLETION_DIR=$HOME/.bash_completion.d
source $BASH_COMPLETION

#------------------------------------------------------------
# PATH
#------------------------------------------------------------

[ -d $HOME/bin ]        && export PATH=$HOME/bin:$PATH
[ -d $HOME/local/bin ]  && export PATH=$HOME/local/bin:$PATH
[ -d $HOME/share/man ]  && export MANPATH=:$MANPATH:$HOME/share/man
[ -d $HOME/python ]     && export PYTHONPATH=$HOME/python:$PYTHONPATH
[ -f $HOME/.pystartup ] && export PYTHONSTARTUP=$HOME/.pystartup

[ -d $HOME/dotfiles/gnome-terminal-colors-solarized/ ] && export PATH=$HOME/dotfiles/gnome-terminal-colors-solarized/:$PATH

#------------------------------------------------------------
# PROMPT
#------------------------------------------------------------

#   How many characters of the $PWD should be kept
function small_pwd {
  local pwdmaxlen=30
#   Indicator that there has been directory truncation:
#trunc_symbol="<"
  local trunc_symbol="..."
  local my_pwd=${PWD/#$HOME/\~}
  if [ ${#my_pwd} -gt $pwdmaxlen ]; then
    local pwdoffset=$(( ${#my_pwd} - $pwdmaxlen ))
    newPWD="${trunc_symbol}${my_pwd:$pwdoffset:$pwdmaxlen}"
  else
    newPWD=${my_pwd}
  fi
  echo $newPWD
}

NO_COLOUR="\[\033[0m\]"
ORANGE="\[\033[0;33m\]"
RED="\[\033[31m\]"
YELLOW="\[\033[0;32m\]"
GREEN="\[\033[32m\]"
BLUE="\[\033[0;34m\]"
PINK="\[\033[0;35m\]"

RET_VALUE='$(echo $RET)'
RET_SMILEY='$(if [ $RET -eq 0 ]; then echo -ne "\[\033[32m\];)> "; else echo -ne "\[\033[01;31m\]:(((> "; fi; echo -ne "\[\033[0m\]")'

__git_ps1 ()
{
    local b="$(git symbolic-ref HEAD 2>/dev/null)";
    if [ -n "$b" ]; then
        printf " (%s)" "${b##refs/heads/}";
    fi
}

function my_git_ps1 {
    # Don't use __git_ps1 on directory that are on NFS
    if [ -n "$FORCE_GIT_PS1" ] || echo $PWD | egrep -q "^/work/"; then
        __git_ps1 "$1"
    fi
}

DOMAIN=$(domainname)
if [ "$DOMAIN" == "nice.arm.com" ]; then
    COLORCLUSTER="\[\033[47m\]"  # Grey
elif [ "$DOMAIN" == "cambridge.arm.com" ]; then
    COLORCLUSTER="\[\033[42m\]"  # Green
elif [ "$DOMAIN" == "nadc.arm.com" ]; then
    COLORCLUSTER="\[\033[45m\]"  # Purple
fi
PROMPT_COMMAND='RET=$?;history -a'

PS1="$ORANGE\t$NO_COLOUR\
:\
${COLORCLUSTER}\h$NO_COLOUR\
:\
$BLUE\$(small_pwd)$PINK\
\$(my_git_ps1 :$GREEN\(%s\)$NO_COLOUR)\
$RET_SMILEY\
"

export GIT_PS1_SHOWDIRTYSTATE=YES
export GIT_PS1_SHOWSTASHSTATE=YES

#------------------------------------------------------------
# CCACHE
#------------------------------------------------------------

if hash ccache 2>&- ; then
    export CCACHE_DIR=/tmp/.ccache
    alias g++="ccache g++"
    alias gcc="ccache gcc"
    alias cc="ccache cc"
    alias c++="ccache c++"
fi

#------------------------------------------------------------
# ALIAS
#------------------------------------------------------------

[ -e $HOME/.aliases ] && source $HOME/.aliases
