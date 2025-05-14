return {
  "nvim-lualine/lualine.nvim",
  config = function()
    local project_root = vim.fn.getcwd()
    local main_buffer_name = ""

    local function get_buffer_address_as_name()
      -- If filetype is 'neo-tree' or 'toggleterm', use main_buffer_name conditionally
      if vim.bo.filetype == "neo-tree" or vim.bo.filetype == "toggleterm" then
        if main_buffer_name == "" then return "" end
        local path = vim.fn.fnamemodify(main_buffer_name, ":h")
        local filename = vim.fn.fnamemodify(main_buffer_name, ":t")
        local relative_path = string.gsub(path, "^" .. vim.pesc(project_root), "")
        return relative_path .. "/" ..  "%#LualineFilename#" .. filename .. "%#Normal#"
      else
        -- Otherwise, update main_buffer_name and return the relative path
        main_buffer_name = vim.fn.expand('%:p')
        local path = vim.fn.fnamemodify(main_buffer_name, ":h")
        local filename = vim.fn.fnamemodify(main_buffer_name, ":t")
        local relative_path = string.gsub(path, "^" .. vim.pesc(project_root), "")
        return relative_path .. "/" ..  "%#LualineFilename#" .. filename .. "%#Normal#"
      end
    end

    -- Lualine configuration setup
    require('lualine').setup({
      sections = {
        lualine_a = {},
        lualine_b = { 'branch' }, -- Display git branch
        lualine_c = { get_buffer_address_as_name }, -- Custom function for buffer name
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      options = {
        theme = {
          normal = {
            a = { fg = '#C0C0C0', bg = '#000' },
            b = { fg = '#C0C0C0', bg = '#000' },
            c = { fg = '#C0C0C0', bg = '#000' }
          },
          inactive = {
            a = { fg = '#C0C0C0', bg = '#000' },
            b = { fg = '#C0C0C0', bg = '#000' },
            c = { fg = '#C0C0C0', bg = '#000' }
          }
        },
        section_separators = '',
        component_separators = '',
        globalstatus = true        -- Use global statusline keep true so doesnt disappear when opening neo-tree
      }
    })
  end
}

