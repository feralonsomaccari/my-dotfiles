return {
  "famiu/bufdelete.nvim",
  config = function()
    vim.keymap.set("n", "<Leader>q", require("bufdelete").bufdelete, { noremap = true, silent = true })
  end,
}
