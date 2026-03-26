return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")
    dashboard.nvim_web_devicons.enabled = false
    dashboard.section.mru.val = { { type = "padding", val = 0 } }
    dashboard.section.header.val = {}

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "BDeletePost*",
      callback = function(event)
        local fallback_name = vim.api.nvim_buf_get_name(event.buf)
        local fallback_ft = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
        local fallback_on_empty = fallback_name == "" and fallback_ft == ""

        if fallback_on_empty then
          require("alpha").start(false)
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function()
        local bufs = vim.tbl_filter(function(b)
          return vim.api.nvim_buf_is_valid(b)
            and vim.api.nvim_buf_get_option(b, "buflisted")
        end, vim.api.nvim_list_bufs())

        if #bufs <= 1 then
          vim.defer_fn(function()
            local buf = vim.api.nvim_get_current_buf()
            local name = vim.api.nvim_buf_get_name(buf)
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if name == "" and ft == "" then
              require("alpha").start(false)
            end
          end, 0)
        end
      end,
    })
  end,
}
