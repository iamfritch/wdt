# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific aliases and functions
export PATH=$PATH:~/bin
export PS1="${debian_chroot:+($debian_chroot)}\[\033[0;35m\]\u\[\033[0;30m\]@\[\033[0;32m\]\h\[\033[0;30m\]:\[\033[0;34m\]\w\[\033[1;35m\]\$>\[\033[0;35m\]"

alias ls='ls --color=tty'
alias grep='grep --color=tty'
alias ll='ls -l --color=tty'
alias la='ls -A'
alias l.='ls -d .* --color=tty'
