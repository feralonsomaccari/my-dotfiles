#!/bin/bash
set -x

read -p "Are you in Mobile (y/n)? [n]: " mobile
mobile=${mobile:-n}

# INSTALL NVIM CONF
mkdir -p ~/.config/nvim/
ln -sf "$(realpath "$(pwd)/nvim")" ~/.config/nvim
echo "Symlinked Nvim config"

if [[ "$mobile" == "y" ]]; then
  # INSTALL TERMUX CONF
  mkdir -p ~/.termux/
  ln -sf "$(realpath "$(pwd)/termux/termux.properties")" ~/.termux/termux.properties
  echo "Symlinked termux config"
else
  # INSTALL ALACRITTY CONF
  mkdir -p ~/.config/alacritty/
  ln -sf "$(realpath "$(pwd)/alacritty")" ~/.config/alacritty
  echo "Symlinked alacritty config"

  # INSTALL NEWSBOAT CONF
  mkdir -p ~/.newsboat/
  ln -sf "$(realpath "$(pwd)/newsboat/config")" ~/.newsboat/config
  ln -sf "$(realpath "$(pwd)/newsboat/urls")" ~/.newsboat/urls
  echo "Symlinked newsboat config"

  # INSTALL MPV CONF
  mkdir -p ~/.config/mpv/
  ln -sf "$(realpath "$(pwd)/mpv")" ~/.config/mpv
  echo "Symlinked mpv config"

  # INSTALL p10k CONF
  ln -sf "$(realpath "$(pwd)/.p10k.zsh")" ~/.p10k.zsh
  echo "Symlinked p10k config"

  # INSTALL tmux CONF
  ln -sf "$(realpath "$(pwd)/tmux/.tmux.conf")" ~/.tmux.conf
  echo "Symlinked tmux config"

  touch .zshrc_secrets
  echo "Env file created please add envs"



fi

