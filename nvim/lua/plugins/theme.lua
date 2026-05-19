return {
  "sainnhe/gruvbox-material",
  config = function()
    vim.cmd("colorscheme gruvbox-material")

    local palette = {}
    for line in io.lines(vim.fn.expand("~/dotfiles/colors/palette.sh")) do
      local k, v = line:match('^export%s+(COLOR_%w+)="(#%x+)"')
      if k then palette[k] = v end
    end

    local mainColor = palette.COLOR_BG
    local mainLightColor = palette.COLOR_WHITE
    local fgColor = palette.COLOR_FG

    vim.api.nvim_set_hl(0, "Normal", { bg = mainColor, fg = fgColor })
    vim.api.nvim_set_hl(0, "VertSplit", { fg = mainColor })
    vim.api.nvim_set_hl(0, "WinSeparator", { fg = mainColor })

    -- Sign column blends into buffer (no off-color gutter strip)
    vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })

    -- Cursor line number: matches LineNr (tracks any future LineNr change)
    vim.api.nvim_set_hl(0, "CursorLineNr", { link = "LineNr" })

    -- Highlight for Floats Windows
    vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeBorder" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = "NONE", bg = mainColor })

    -- Statusline: active and inactive both blend
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })

    -- Git / comment colors (all track LineNr — change LineNr to recolor everything)
    vim.api.nvim_set_hl(0, "Comment", { link = "LineNr" })
    vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })

    -- Neo-tree colors
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = mainColor })
    vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = mainColor })
    vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { link = "CursorLine" })
    vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { link = "LineNr" })
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { link = "LineNr" })
    vim.api.nvim_set_hl(0, "NeoTreeDotfile", { fg = mainLightColor })
    vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = mainLightColor })
    -- bold/italic = false defends against gruvbox-material making the root name bold
    vim.api.nvim_set_hl(0, "NeoTreeRootName", { bold = false, italic = false, fg = mainLightColor })
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = mainLightColor })
  end,
}
