# Shortcuts
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias tmp="cd ~/tmp"
alias -g ...='../..'
alias -g ....='../../..'

# ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"

if ls --color > /dev/null 2>&1; then
  colorflag="--color" # GNU `ls`
else
  colorflag="-G" # BSD `ls`
fi

alias ll="ls -lhF ${colorflag}"
alias la="ll -A"
unset colorflag

# git
alias gc="git checkout"
alias ga="git add"
alias gs="git status"

alias hist='git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn] %Cgreen(%cr)" --decorate --date=relative'
alias histg='hist --graph'
alias hists='hist --numstat'

# sublime
alias st="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias stt="st ./"

# misc
function server() {
  local port="${1:-8000}"
  ruby -run -ehttpd . -p "${port}"
}

alias ruby19="chruby ruby-1.9.3-p551"
alias ruby22="chruby ruby-2.2.4"
