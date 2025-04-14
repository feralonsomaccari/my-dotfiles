return {
  'ruifm/gitlinker.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  config = function()
    require('gitlinker').setup({
      opts = {
        action_callback = require("gitlinker.actions").open_in_browser,
        remote = nil,
        add_current_line_on_normal_mode = false,
        mappings = nil,
      },
      callbacks = {
        ["github.dowjones.net"] = function(url_data)
          url_data.rev = "main"
          return require("gitlinker.hosts").get_github_type_url(url_data)
        end,
        ["github.com"] = function(url_data)
          url_data.rev = "main"
          return require("gitlinker.hosts").get_github_type_url(url_data)
        end,
      },
    })

    vim.keymap.set("n", "<leader>gy", function()
      require('gitlinker').get_buf_range_url('n')
    end, { noremap = true, silent = true, desc = "Get Git link for line" })

    vim.keymap.set("v", "<leader>gy", function()
      require('gitlinker').get_buf_range_url('v')
    end, { noremap = true, silent = true, desc = "Get Git link for range" })

    vim.api.nvim_set_keymap('n', '<leader>gr', '<cmd>lua require"gitlinker".get_repo_url()<cr>', { silent = true })
  end,
}
