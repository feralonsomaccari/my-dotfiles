# My NVIM Configuration

Neovim configuration managed with [lazy.nvim](https://github.com/folke/lazy.nvim). Plugin specs live in `lua/plugins/`, one file per plugin.

## Plugins

### UI / theme

| Plugin | Spec | What it does |
|---|---|---|
| [gruvbox-material](https://github.com/sainnhe/gruvbox-material) | `theme.lua` | Colorscheme. Reads `$DOTFILES/colors/palette.sh` for shared palette. |
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | `alpha.lua` | Start screen / dashboard. |
| [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons) | `alpha.lua` | File-type icons used across UI plugins. |
| [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) | `neo-tree.lua` | File explorer sidebar. |
| [nvim-highlight-colors](https://github.com/brenoprata10/nvim-highlight-colors) | `nvim-highlight-colors.lua` | Renders hex/rgb color literals inline. |

### Git

| Plugin | Spec | What it does |
|---|---|---|
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) | `gitsigns.lua` | Gutter signs and inline blame for git changes. |
| [diffview.nvim](https://github.com/sindrets/diffview.nvim) | `diffview.lua` | Side-by-side diff viewer. |
| [gitlinker.nvim](https://github.com/ruifm/gitlinker.nvim) | `gitlinker.lua` | Generate permalinks to lines on the git host. |

### Notes / docs

| Plugin | Spec | What it does |
|---|---|---|
| [mkdnflow.nvim](https://github.com/jakewvincent/mkdnflow.nvim) | `mkdnflow.lua` | Markdown notebook workflow (links, lists, todos). |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | `render-markdown.lua` | In-buffer markdown rendering (conceals markers, styles headings and code blocks). |

### Miscellaneous

| Plugin | Spec | What it does |
|---|---|---|
| [cellular-automaton.nvim](https://github.com/eandrju/cellular-automaton.nvim) | `cellular.lua` | Runs cellular automata on the current buffer. |
| [duck.nvim](https://github.com/tamton-aquib/duck.nvim) | `duck.lua` | A duck walks around your screen. |

### Navigation / motion

| Plugin | Spec | What it does |
|---|---|---|
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) | `telescope.lua` | Fuzzy finder for files, grep, buffers, etc. |
| [telescope-ui-select.nvim](https://github.com/nvim-telescope/telescope-ui-select.nvim) | `telescope.lua` | Routes `vim.ui.select` through Telescope. |
| [hop.nvim](https://github.com/smoka7/hop.nvim) | `hop.lua` | EasyMotion-style jumping by label. |
| [vim-illuminate](https://github.com/RRethy/vim-illuminate) | `vim-illuminate.lua` | Highlights other occurrences of the word under cursor. |

### Editing

| Plugin | Spec | What it does |
|---|---|---|
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | `cmp.lua` | Completion engine. |
| [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) | `cmp.lua` | LSP completion source for cmp. |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip) | `cmp.lua` | Snippet engine. |
| [vim-react-snippets](https://github.com/mlaursen/vim-react-snippets) | `react-snippets.lua` | React snippet collection. |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | `comment.lua` | Toggle comments by motion. |
| [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) | `comment.lua` | Pick the right comment style based on cursor context (JSX, etc). |
| [visual-surround.nvim](https://github.com/NStefan002/visual-surround.nvim) | `visual-surround.lua` | Surround visual selection with brackets/quotes. |
| [vim-visual-multi](https://github.com/mg979/vim-visual-multi) | `vim-visual-multi.lua` | Multi-cursor editing. |
| [bufdelete.nvim](https://github.com/famiu/bufdelete.nvim) | `bufdelete.lua` | Delete buffers without closing the window. |

### LSP / language tooling

| Plugin | Spec | What it does |
|---|---|---|
| [mason.nvim](https://github.com/williamboman/mason.nvim) | `lsp-config.lua` | Installer for LSP servers, linters, formatters. |
| [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) | `lsp-config.lua` | Bridges Mason with nvim-lspconfig. |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | `lsp-config.lua` | Default LSP server configurations. |
| [none-ls.nvim](https://github.com/nvimtools/none-ls.nvim) | `none-ls.lua` | Use external formatters/linters via the LSP interface. |
| [none-ls-extras.nvim](https://github.com/nvimtools/none-ls-extras.nvim) | `none-ls.lua` | Extra sources for none-ls. |
| [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | `treesitter.lua` | Syntax-aware highlighting and parsing. |
| [godoc.nvim](https://github.com/fredrikaverpil/godoc.nvim) | `godoc.lua` | Go documentation viewer. |

