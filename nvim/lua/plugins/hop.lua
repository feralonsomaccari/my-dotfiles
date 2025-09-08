return {
  "phaazon/hop.nvim",
  branch = "v2",
  config = function()
    require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
    vim.keymap.set("", "f", "<cmd>HopWord<CR>", {})
  end,
}
