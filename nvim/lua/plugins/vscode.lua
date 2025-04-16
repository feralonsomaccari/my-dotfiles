return {
  'sainnhe/gruvbox-material',
  config = function()
    --[[   require('vscode').setup({
      style = 'dark',            -- Choose between two styles: "dark" or "light"
      transparent = false,       -- Enable/Disable transparency
      italic_comments = true,    -- Enable italic comments
      disable_nvimtree_bg = true -- Disable nvim-tree background color
    })
    ]]
    vim.cmd('colorscheme gruvbox-material')

    local mainColor = vim.api.nvim_get_hl_by_name('Normal', true).background or "purple"
    local mainLightColor = '#C0C0C0'
    local grayColor = vim.api.nvim_get_hl_by_name('LineNr', true).foreground or "purple"
    local cursorColor = vim.api.nvim_get_hl_by_name('CursorLine', true).background or "purple"
    local methodColor = vim.api.nvim_get_hl_by_name('@keyword', true).foreground or "purple"

    local variableColor = vim.api.nvim_get_hl_by_name('@variable', true).foreground or "purple"



    -- Highlight for relative line numbers (not active line)
    vim.api.nvim_set_hl(0, 'LineNr', { fg = mainColor })
    -- Highlight for the current line number (active line)
    vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = grayColor })

    -- Highlight for Floats Windows
    vim.api.nvim_set_hl(0, 'FloatBorder', { fg = variableColor, bg = mainColor })
    vim.api.nvim_set_hl(0, 'NormalFloat', { fg = "NONE", bg = "NONE" })
    -- vim.api.nvim_set_hl(0, 'FloatTitle', {fg = "NONE", bg = "NONE"})

    -- File name in Lualine
    vim.api.nvim_set_hl(0, "LualineFilename", { fg = methodColor, bg = "NONE" })
    vim.api.nvim_set_hl(0, 'StatusLine', { fg = mainColor })


    vim.api.nvim_set_hl(0, 'VertSplit', { fg = mainColor })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = mainColor })

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
