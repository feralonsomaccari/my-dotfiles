return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
  config = function()
    vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", { noremap = true, silent = true })
    vim.keymap.set("n", "<D-e>", ":Neotree toggle<CR>", { noremap = true, silent = true })

    require("nvim-web-devicons").setup {
      color_icons = false,
      default = false,
    }

    require("neo-tree").setup({
      sources = { "filesystem", "git_status" },
      filesystem = {
        filtered_items = {
          visible = true
        },
        hijack_netrw_behavior = "disabled",
      },
      close_if_last_window = true,
      source_selector = {
        winbar = false
      },
      disabled_filetypes = { 'packer', 'NVimTree' },
      git_status = {
        sort_untracked_first = true,
      },
      default_component_configs = {
        icon = {
          enabled = true,
          -- folder_empty = "◎",
          -- folder_closed = "◎",
          -- folder_open = "◯",
          file = "",
          directory = "",
          symlink = "",
          bookmark = "",
          default = "",
          provider = function(icon, node, state)
            if node.type == "file" or node.type == "terminal" then
              local success, web_devicons = pcall(require, "nvim-web-devicons")
              local name = node.type == "terminal" and "terminal" or node.name
              if success then
                local devicon, hl = web_devicons.get_icon(name)
                icon.text = devicon or icon.text
                icon.highlight = "NeoTreeFileIcon"
              end
            end
          end,
          highlight = "NeoTreeFileIcon",
        },
        git_status = {
          symbols = {
            added     = "✔",
            modified  = "✎",
            deleted   = "×",
            renamed   = "➜",
            untracked = "*",
            ignored   = "",
            unstaged  = "∪",
            staged    = "✓",
            conflict  = "⚔",
          },
        },
        diagnostics = {
          symbols = {
            hint = "",
            info = "",
            warn = "w",
            error = "e",
          },
        },
        file_size = {
          enabled = false,
        },

      },
      buffers = {
        follow_current_file = {
          enabled = true,
        },
      },
      window = {
        width = 36,
        border = "none",
        position = "float",
        title = "",
        mappings = {
          ["A"]          = "git_add_all",
          ["eq"]         = "git_add_file",
          ["er"]         = "git_revert_file",
          ["ew"]         = "git_unstage_file",
          ["ed"]         = "git_remove_file",
          ["ee"]         = "git_commit",
          ["ep"]         = "git_push",
          ['<leader>fp'] = function(state)
            local node = state.tree:get_node()
            if node and node.type == "directory" then
              require('telescope.builtin').find_files({ cwd = node.path })
            elseif node and node.type == "file" then
              require('telescope.builtin').find_files({ cwd = vim.fn.fnamemodify(node.path, ":h") })
            else
              print("Invalid node type")
            end
          end,
          ['<leader>f/'] = function(state)
            local node = state.tree:get_node()
            if node and node.type == "directory" then
              require('telescope.builtin').live_grep({ cwd = node.path })
            elseif node and node.type == "file" then
              require('telescope.builtin').live_grep({ cwd = vim.fn.fnamemodify(node.path, ":h") })
            else
              print("Invalid node type")
            end
          end,
          ["q"]          = "",
          ["f"]          = "",
        }
      }
    })
  end
}
