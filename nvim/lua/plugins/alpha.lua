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
  end,
}
