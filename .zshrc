# Resolve the dotfiles repo location from ~/.zshrc's own symlink, so nothing
# depends on the repo being named "dotfiles" or living in a fixed place.
export DOTFILES="${${:-$(readlink ~/.zshrc 2>/dev/null || echo ~/.zshrc)}:A:h}"

[ -f "$DOTFILES/.zshrc_secrets" ] && source "$DOTFILES/.zshrc_secrets"

# Machine-specific config (Homebrew/PATH, work tooling, etc.).
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Ensure ~/.local/bin is on PATH (where install.sh symlinks open-url). Guarded so
# it isn't prepended repeatedly across nested shells.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

# Stops last login message (only needs to exist; skip the syscall if present)
[ -f ~/.hushlogin ] || touch ~/.hushlogin

# History
unsetopt share_history # Prevents shared history between shells
setopt inc_append_history  # Save commands as they are executed
setopt append_history      # Append to the history file instead of overwriting it

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# NVM
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Powerlevel10k theme — source from whichever install location exists
# (manual clone on macOS, pacman/AUR path on Arch).
for _p10k in \
  ~/powerlevel10k/powerlevel10k.zsh-theme \
  /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme \
  /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme; do
  [ -r "$_p10k" ] && { source "$_p10k"; break; }
done
unset _p10k
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
 [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Preferred editor for local and remote sessions conf
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'
export PAGER='nvim +Man!'


export LANG=en_US.UTF-8


# Search and cd to a root project
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

# Wttr wrapper
weather() {
    curl -s "wttr.in/${1}?${2:-1}"
}

# Aliases
alias fp='search_projects'
alias v='nvim'
alias nvimconf='cd "$DOTFILES/nvim"'
alias nvimconfig='cd "$DOTFILES/nvim"'
alias vimdiff='nvim -d'
# Colored ls: GNU ls (Arch, or coreutils' gls on macOS) uses --color=auto;
# BSD ls (stock macOS) uses -G.
if ls --color=auto >/dev/null 2>&1; then
  alias ls='ls --color=auto'
else
  alias ls='ls -G'
fi

# Keybindings
bindkey '^H' backward-kill-word
bindkey '^J' history-search-forward
bindkey '^K' history-search-backward


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Tmux Initialization
if command -v tmux >/dev/null 2>&1; then
  if [ -z "$TMUX" ] && [ -t 1 ]; then
    tmux attach -t default || tmux new-session -s default -n Q \; \
      new-window -n W \; \
      new-window -n E \; \
      new-window -n A \; \
      new-window -n S \; \
      new-window -n D \; \
      select-window -t 0
  fi
fi

# Initialize zsh completions.
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

zstyle ':fzf-tab:*' accept-line enter
[ -f ~/.fzf-tab/fzf-tab.zsh ] && source ~/.fzf-tab/fzf-tab.zsh

