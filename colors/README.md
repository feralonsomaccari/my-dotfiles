# colors

Single source of truth for the color palette shared across alacritty, p10k, nvim, and tmux.

## Files

- `palette.sh` — the palette. Defines `COLOR_BG`, `COLOR_FG`, `COLOR_RED`, etc. as shell exports. Edit this file to change colors everywhere.
- `generate-alacritty-colors.sh` — generates `alacritty/colors.toml` from `palette.sh`. Alacritty can't read shell vars, so it needs this static TOML.

## How each tool consumes the palette

| Tool | How it reads colors | Action on palette change |
|---|---|---|
| alacritty | Imports the generated `alacritty/colors.toml` | Run `generate-alacritty-colors.sh` |
| p10k | Sources `palette.sh` directly | Open a new shell (or `source ~/.p10k.zsh`) |
| nvim | Parses `palette.sh` in `nvim/lua/plugins/theme.lua` | Restart nvim (or re-source the theme file) |
| tmux | `run-shell` sources `palette.sh`, sets tmux env vars | `tmux source-file ~/.tmux.conf` or restart tmux |

## Workflow

1. Edit `palette.sh`.
2. Run `./generate-alacritty-colors.sh`.

The git hooks at `hooks/post-merge` and `hooks/post-checkout` regenerate alacritty colors automatically if `palette.sh` changes during a pull or branch switch.

## Adding a new color

1. Add `export COLOR_FOO="#hex"` to `palette.sh`.
2. Reference `$COLOR_FOO` in p10k or tmux; `palette.COLOR_FOO` in nvim.
3. If alacritty needs it, add the line to `generate-alacritty-colors.sh` and re-run.
