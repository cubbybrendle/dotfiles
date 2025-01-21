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
source ${0:h}/lib/venv.zsh
source ${0:h}/lib/helpers.zsh

# fzf
# [[ \$- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null
[[ \$- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.zsh" 2> /dev/null
source "/opt/homebrew/opt/fzf/shell/key-bindings.zsh"
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"

autoload -Uz compinit

dump=$HOME/.zcompdump
if [[ -s "$dump" && (! -s "$dump.zwc" || "$dump" -nt "$dump.zwc" ) ]]; then
  zcompile "$dump"
fi
unset dump

compinit -C

export PATH="/usr/local/bin:/usr/local/sbin:$HOME/bin:$PATH"
eval $(/opt/homebrew/bin/brew shellenv)
