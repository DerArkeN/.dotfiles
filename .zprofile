export XDG_CONFIG_HOME=$HOME/.config
VIM="nvim"

alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

export GIT_EDITOR=$VIM
export DOTFILES=$HOME/.dotfiles

