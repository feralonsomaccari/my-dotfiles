# my-dotfiles

My dotfiles, so I can take my setup everywhere. Works on macOS and Arch.

## Install

```sh
./install.sh
```

Symlinks every config into place and asks whether you're on **(d)esktop** or **(m)obile** (to use for example Termux). 
Existing files are backed up to `*.bak`. this will never installs anything for you but will warn you about missing dependencies.

## What's here

| Tool        | Config                |
|-------------|-----------------------|
| Shell       | `.zshrc` (Zsh + p10k) |
| Editor      | `nvim/`               |
| Terminal    | `alacritty/`          |
| Multiplexer | `tmux/.tmux.conf`     |
| Keymaps     | `karabiner/`          |
| News        | `newsboat/`           |
| Media       | `mpv/` (+ yt-dlp)     |
| Mobile      | `termux/`             |

## Machine-specific config

Anything specific to a particular machine can be set in `~/.zshrc.local`

## Colors

`colors/palette.sh` is the single source of truth. Alacritty, p10k, and nvim all
read it. Edit a hex there and run `colors/generate-alacritty-colors.sh` to update alacritty automatically. 
Git hooks (`hooks/`) also regenerate automatically on checkout/merge.
