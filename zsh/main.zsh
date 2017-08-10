autoload -U compinit

# History

HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt share_history

# Misc Options

setopt autocd
setopt promptsubst
setopt interactivecomments

export EDITOR="nvim"
export PAGER="less"
export LESS="-R"

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

source ${0:h}/lib/completion.zsh
source ${0:h}/lib/keybindings.zsh
source ${0:h}/lib/termsupport.zsh
source ${0:h}/lib/theme.zsh
source ${0:h}/lib/helpers.zsh

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
chruby ruby-2.3.1

# nvm
export NVM_DIR=~/.nvm
nvm() {
  [ -s $NVM_DIR/nvm.sh ] && . $NVM_DIR/nvm.sh
  nvm $@
}

export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"

compinit
