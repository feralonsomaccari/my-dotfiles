#!/usr/bin/env bash
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    echo "Refusing to overwrite non-symlink: $dest" >&2
    exit 1
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

read -p "Are you in Mobile (y/n)? [n]: " mobile
mobile=${mobile:-n}

if [ -d "$DOTFILES/.git" ]; then
  for hook in "$DOTFILES"/hooks/*; do
    link "$hook" "$DOTFILES/.git/hooks/$(basename "$hook")"
  done
fi

link "$DOTFILES/nvim" "$HOME/.config/nvim"

if [ "$mobile" = "y" ]; then
  link "$DOTFILES/termux/termux.properties" "$HOME/.termux/termux.properties"
else
  "$DOTFILES/colors/generate-alacritty-colors.sh"

  link "$DOTFILES/alacritty"          "$HOME/.config/alacritty"
  link "$DOTFILES/newsboat/config"    "$HOME/.newsboat/config"
  link "$DOTFILES/newsboat/urls"      "$HOME/.newsboat/urls"
  link "$DOTFILES/mpv"                "$HOME/.config/mpv"
  link "$DOTFILES/.p10k.zsh"          "$HOME/.p10k.zsh"
  link "$DOTFILES/tmux/.tmux.conf"    "$HOME/.tmux.conf"

  if [ ! -f "$DOTFILES/.zshrc_secrets" ]; then
    touch "$DOTFILES/.zshrc_secrets"
    echo "Created $DOTFILES/.zshrc_secrets — add secrets here"
  fi
fi

echo "Install complete."
