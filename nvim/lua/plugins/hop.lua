return {
  "smoka7/hop.nvim",
  version = "*",
  keys = {
    { "f", "<cmd>HopWord<CR>", mode = "" },
  },
  config = function()
    require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
  end,
}
