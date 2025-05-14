return {
  'sainnhe/gruvbox-material',
  config = function()
    vim.cmd('colorscheme gruvbox-material')

    local mainColor = vim.api.nvim_get_hl_by_name('Normal', true).background or "purple"
    local mainLightColor = '#C0C0C0'
    local grayColor = vim.api.nvim_get_hl_by_name('LineNr', true).foreground or "purple"
    local cursorColor = vim.api.nvim_get_hl_by_name('CursorLine', true).background or "purple"
    local methodColor = vim.api.nvim_get_hl_by_name('@keyword', true).foreground or "purple"

    vim.api.nvim_set_hl(0, 'VertSplit', { fg = mainColor })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = mainColor })

    -- Cursor and LineNr
    vim.api.nvim_set_hl(0, 'LineNr', { fg = mainColor })
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = grayColor })

    -- Highlight for Floats Windows
    vim.api.nvim_set_hl(0, 'FloatBorder', { link = "TelescopeBorder" })
    vim.api.nvim_set_hl(0, 'NormalFloat', { fg = "NONE", bg = mainColor })
    -- vim.api.nvim_set_hl(0, 'FloatTitle', {fg = "NONE", bg = "NONE"})

    -- File name in Lualine
    vim.api.nvim_set_hl(0, "LualineFilename", { fg = methodColor, bg = "NONE" })
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = mainColor })

    -- Git colors
    vim.api.nvim_set_hl(0, "Comment", { fg = grayColor })
    vim.api.nvim_set_hl(0, "@comment", { link = "Comment" })
    vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment" })

    -- Neo-tree colors
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = mainColor })
    vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = mainColor })
    vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', { bg = cursorColor })
    vim.api.nvim_set_hl(0, 'NeoTreeGitIgnored', { fg = grayColor })
    vim.api.nvim_set_hl(0, 'NeoTreeIndentMarker', { bg = 'NONE', fg = grayColor })
    vim.api.nvim_set_hl(0, 'NeoTreeDotfile', { fg = mainLightColor })
    vim.api.nvim_set_hl(0, 'NeoTreeFileName', { fg = mainLightColor })
    vim.api.nvim_set_hl(0, 'NeoTreeRootName', { bold = false, italic = false, fg = mainLightColor })
    vim.api.nvim_set_hl(0, 'NeoTreeDirectoryName', { fg = mainLightColor })
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = mainLightColor }) -- White icons
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = mainLightColor }) -- White folder names
    vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = mainLightColor })      -- Change all file icon colors
  end
}
