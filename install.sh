#!/usr/bin/env bash
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    if [ -e "$dest.bak" ]; then
      echo "Refusing to overwrite existing backup: $dest.bak" >&2
      exit 1
    fi
    mv "$dest" "$dest.bak"
    echo "Backed up existing $dest -> $dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

OS="$(uname)"

while true; do
  read -p "Install for (m)obile or (d)esktop? [d]: " platform
  platform=${platform:-d}
  case "$platform" in
    m|mobile)  platform=mobile;  break ;;
    d|desktop) platform=desktop; break ;;
    *) echo "Please answer 'm' (mobile) or 'd' (desktop)." >&2 ;;
  esac
done

if [ -d "$DOTFILES/.git" ]; then
  for hook in "$DOTFILES"/hooks/*; do
    link "$hook" "$DOTFILES/.git/hooks/$(basename "$hook")"
  done
fi

link "$DOTFILES/.zshrc" "$HOME/.zshrc"
link "$DOTFILES/nvim" "$HOME/.config/nvim"
link "$DOTFILES/bin/open-url" "$HOME/.local/bin/open-url"

if [ "$platform" = "mobile" ]; then
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

  if [ ! -f "$HOME/.zshrc.local" ]; then
    touch "$HOME/.zshrc.local"
    echo "Created $HOME/.zshrc.local — add machine-specific config here"
  fi
fi

# Warn about missing dependencies (no auto-install).
if [ "$platform" = "desktop" ]; then
  deps="nvim tmux fzf"

  # Neovim toolchain. Lazy/Mason bootstrap plugins on first launch, but these
  # system tools must already be present for the build steps to succeed:
  #   git, cc        -> telescope-fzf-native (make) + treesitter parser compile
  #   node, npm      -> Mason LSPs (vtsls/html/cssls/eslint), prettierd, js-debug
  #   go             -> gopls, delve, godoc's `go install` step
  #   stylua, clang-format, prettierd -> none-ls formatters
  deps="$deps git cc node npm go stylua clang-format prettierd"

  if [ "$OS" = "Darwin" ]; then
    deps="$deps newsboat mpv yt-dlp"
  else
    # Linux/Arch: `open` is provided by xdg-utils (xdg-open); clipboard needs xclip.
    deps="$deps newsboat mpv yt-dlp xdg-open xclip"
  fi

  missing=""
  for dep in $deps; do
    command -v "$dep" >/dev/null 2>&1 || missing="$missing $dep"
  done

  if [ -n "$missing" ]; then
    echo "Warning: missing dependencies:$missing" >&2
    if [ "$OS" != "Darwin" ]; then
      echo "  On Arch, most come from:" >&2
      echo "    sudo pacman -S neovim tmux fzf newsboat mpv yt-dlp git base-devel go nodejs npm stylua clang xdg-utils xclip" >&2
      echo "  Note: 'cc' is in base-devel, 'clang-format' is in clang, 'xdg-open' is in xdg-utils." >&2
      echo "  prettierd is not in pacman — install with: npm install -g @fsouza/prettierd" >&2
    fi
  fi

  # fzf-tab is a manual clone (not a package); .zshrc sources it from ~/.fzf-tab.
  if [ ! -f "$HOME/.fzf-tab/fzf-tab.zsh" ]; then
    echo "Warning: fzf-tab not found at ~/.fzf-tab" >&2
    echo "  Install with: git clone https://github.com/Aloxaf/fzf-tab ~/.fzf-tab" >&2
  fi
fi

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) echo "Note: add \$HOME/.local/bin to your PATH so open-url is found." >&2 ;;
esac

echo "Install complete."
