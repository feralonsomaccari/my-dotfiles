return {
  "smoka7/hop.nvim",
  version = "*",
  config = function()
    require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    vim.keymap.set("", "f", "<cmd>HopWord<CR>", {})
  end,
}
