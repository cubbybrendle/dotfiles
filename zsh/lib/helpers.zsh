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
alias gco="git checkout"
alias ga="git add"
alias gs="git status"

alias hist='git log --pretty=format:"%C(yellow)%h%Cred%d %Creset%s%Cblue [%cn] %Cgreen(%cr)" --decorate --date=relative'
alias histg='hist --graph'
alias hists='hist --numstat'

# sublime
alias st="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias stt="st ./"

# local server for static files
function server() {
  local port="${1:-8000}"
  ruby -run -ehttpd . -p "${port}"
}

# shout out to ruby-install
function node-install() {
    node-build "$1" "$HOME/.nodes/node-$1"
}

# Open zoom meeting without opening a browser tab.
# Takes string parameter with format "confno=XXXXXXX&pwd=YYYYYYYYY"
funtion _zoommtg() {
  open "zoommtg://zoom.us/join?$1"
}
