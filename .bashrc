#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
. "$HOME/.cargo/env"
export PATH="$HOME/.npm-global/bin:$PATH"

export PATH=/home/grey/.cabal/bin:/home/grey/.local/bin:/home/grey/.cargo/bin:/home/grey/.zero/bin:/home/grey/.local/share/gem/ruby/3.4.0/bin:/home/grey/.npm-global/bin:/home/grey/.cabal/bin:/home/grey/.cabal/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/grey/.cabal/bin:/home/grey/.ghcup/bin:/home/grey/.ghcup/bin:/home/grey/.ghcup/bin:/home/grey/.ghcup/bin:/home/grey/bin/gyb

export PATH=/home/grey/.cabal/bin:/home/grey/.local/bin:/home/grey/.cargo/bin:/home/grey/.zero/bin:/home/grey/.local/share/gem/ruby/3.4.0/bin:/home/grey/.npm-global/bin:/home/grey/.cabal/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/home/grey/.cabal/bin:/home/grey/.ghcup/bin:/home/grey/.ghcup/bin:/home/grey/.ghcup/bin:/home/grey/bin/gyb
