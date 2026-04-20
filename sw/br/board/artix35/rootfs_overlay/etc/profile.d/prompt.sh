#!/bin/sh
if [ -n "$SSH_TTY" ] || [ -n "$SSH_CONNECTION" ]; then
    IS_SSH=1
else
    IS_SSH=0
fi
if [ "$(id -u)" -eq 0 ]; then
    if [ "$IS_SSH" -eq 1 ]; then
        # Root + SSH: цветной (красный пользователь, синяя директория)
        export PS1='\033[01;31m\u@\h\033[00m:\033[01;34m\w\033[00m# '
    else
        # Root + UART: монохромный
        export PS1='\u@\h:\w# '
    fi
else
    if [ "$IS_SSH" -eq 1 ]; then
        # User + SSH: цветной (зелёный пользователь, синяя директория)
        export PS1='\033[01;32m\u@\h\033[00m:\033[01;34m\w\033[00m$ '
    else
        # User + UART: монохромный
        export PS1='\u@\h:\w$ '
    fi
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# export PATH="$HOME/bin:$PATH"
