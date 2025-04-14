# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

[ -f ~/dotfiles/.zshrc_secrets ] && source ~/dotfiles/.zshrc_secrets

# Stops last login message
touch ~/.hushlogin

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
#export PATH="$PATH:$(npm root -g)"
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/share/npm/bin:$PATH
export PATH="/opt/homebrew/Cellar/mongodb-community@4.4/4.4.29/bin:$PATH"

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Load Oh My Zsh.
source $ZSH/oh-my-zsh.sh

# Powerlevel10k theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# User configuration
PS1='%n@%m %~$ '
PS1="%n@%~ > "

bindkey '^H' backward-kill-word
bindkey '^J' history-search-forward
bindkey '^K' history-search-backward

# export MANPATH="/usr/local/man:$MANPATH"
 
# Disable shared history between tabs
unsetopt share_history

# Optional, improves history handling (you can add these if you want better history management):
setopt inc_append_history  # Save commands as they are executed
setopt append_history      # Append to the history file instead of overwriting it

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# NVM (move nvm loading above instant prompt)
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Jira-cli
export JIRA_AUTH_TYPE=''
export PAGER='nvim +Man!'
export MANPAGER='nvim +Man!'

# Define a function to search and cd to a root project
search_projects() {
  local project_dirs=("$W_PROJECTS_DIR" "$P_PROJECTS_DIR")  # Add more directories
  local project=$(find "${project_dirs[@]}" -maxdepth 1 -mindepth 1 -type d | fzf)
  
  if [ -n "$project" ]; then
    cd "$project" || return 1
  fi
}

# Aliases
alias fp='search_projects'
alias c='clear'
alias v='nvim .'
alias nvimconf='cd ~/dotfiles/nvim'
alias nvimconfig='cd ~/dotfiles/nvim'
alias ipconfig="ipconfig getifaddr en0"
alias sprintview="jira sprint list --current -a$(jira me)"
alias vimdiff='nvim -d'

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
export NOTES_DIR=/Users/feralonsomaccari/Projects/notes
NOTES_DIR=/Users/feralonsomaccari/Projects/Notes

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
