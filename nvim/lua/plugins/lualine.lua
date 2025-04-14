return {
  "nvim-lualine/lualine.nvim",
  config = function()
    -- Variable to store the main buffer name
    local main_buffer_name = ""
    local project_root = vim.fn.getcwd()

    -- Function to get the main buffer name
    local function get_main_buffer_name()
      if vim.bo.filetype == "neo-tree" or vim.bo.filetype == "toggleterm" then
        if main_buffer_name == "" then
          return ""
        end
        local path = vim.fn.fnamemodify(main_buffer_name, ":h")
        local relative_path = string.gsub(path, "^" .. vim.pesc(project_root), "")
        local filename = vim.fn.fnamemodify(main_buffer_name, ":t")
        return relative_path .. "/" .. "%#LualineFilename#" .. filename .. "%#Normal#"
      else
        main_buffer_name = vim.fn.expand('%:p')
        local path = vim.fn.fnamemodify(main_buffer_name, ":h")
        local filename = vim.fn.fnamemodify(main_buffer_name, ":t")
        local relative_path = string.gsub(path, "^" .. vim.pesc(project_root), "")
        return relative_path .. "/" .. "%#LualineFilename#" .. filename .. "%#Normal#"
        -- return string.gsub(path, "^" .. project_root, "") .. "/" .. "%#LualineFilename#" .. filename .. "%#Normal#"
      end
    end

    -- Set up lualine configuration
    require('lualine').setup({
      sections = {
        lualine_a = {},           -- Remove all other sections
        lualine_b = { 'branch' }, -- Only show git branch
        lualine_c = {
          get_main_buffer_name,   -- Custom function to show the main buffer name
        },
        lualine_x = {},           -- No info on the right
        lualine_y = {},           -- No info on the right
        lualine_z = {}            -- No info in the last section
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          get_main_buffer_name, -- Use the same function for inactive sections
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
      },
      options = {
        theme = {
          normal = {
            a = { fg = '#C0C0C0', bg = '#000' }, -- Change fg (text color) to red
            b = { fg = '#C0C0C0', bg = '#000' },
            c = { fg = '#C0C0C0', bg = '#000' }
          },
          inactive = {
            a = { fg = '#C0C0C0', bg = '#000' }, -- Same here for inactive sections
            b = { fg = '#C0C0C0', bg = '#000' },
            c = { fg = '#C0C0C0', bg = '#000' }
          }
        },
        section_separators = '',   -- Remove section separators
        component_separators = '', -- Remove component separators
        globalstatus = true        -- Set to true for global status line
      }
    })
  end
}
