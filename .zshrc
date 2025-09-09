# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

[ -f ~/dotfiles/.zshrc_secrets ] && source ~/dotfiles/.zshrc_secrets

# Stops last login message
touch ~/.hushlogin

# Disable shared history between tabs
unsetopt share_history

# Optional, improves history handling (you can add these if you want better history management):
setopt inc_append_history  # Save commands as they are executed
setopt append_history      # Append to the history file instead of overwriting it

 # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
 # Initialization code that may require console input (password prompts, [y/n]
 # confirmations, etc.) must go above this block; everything else may go below.
 if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
 fi

# Powerlevel10k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
 [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NVM (move nvm loading above instant prompt)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Homebrew
export PATH=/opt/homebrew/bin:$PATH
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/Cellar/mongodb-community@4.4/4.4.29/bin:$PATH"
# export PATH=$PATH:$(go env GOPATH)/bin

# Preferred editor for local and remote sessions
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'

export LANG=en_US.UTF-8
export NOTES_DIR=/Users/feralonsomaccari/Projects/notes

# Jira-cli
export JIRA_AUTH_TYPE=''
export PAGER='nvim +Man!'

# Yalcmate
export YALCMATE_PACKAGES_DIR=$W_PACKAGES_DIR

# Define a function to search and cd to a root project
search_projects() {
  local project_dirs=("$W_PROJECTS_DIR" "$P_PROJECTS_DIR")  # Add more directories
  local project=$(find "${project_dirs[@]}" -maxdepth 1 -mindepth 1 -type d | fzf)
  
  if [ -n "$project" ]; then
    cd "$project" || return 1
    if [ -f ".nvmrc" ]; then
      nvm use
    fi
  fi
}

# Aliases
alias fp='search_projects'
alias v='nvim'
alias nvimconf='cd ~/dotfiles/nvim'
alias nvimconfig='cd ~/dotfiles/nvim'
alias ipconfig="ipconfig getifaddr en0"
alias vimdiff='nvim -d'
alias opensprint="jira sprint list --current -a$(jira me)"
alias openrep='fertools openrep'
alias openpr='fertools openpr'
alias openpaas='fertools openpaas'
alias openjira='fertools openjira'
alias ls='ls --color=auto'

# Keybindings
bindkey '^H' backward-kill-word
bindkey '^J' history-search-forward
bindkey '^K' history-search-backward

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"


plugins=(zsh-autosuggestions)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#Tmux Initialization
if [ -t 1 ] && [ -z "$TMUX" ]; then
  tmux new-session -n Q \; \
    new-window -n W \; \
    new-window -n E \; \
    new-window -n A \; \
    new-window -n S \; \
    new-window -n D \; \
    select-window -t 0
fi

# fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -U compinit; compinit
source ~/.fzf-tab/fzf-tab.zsh
