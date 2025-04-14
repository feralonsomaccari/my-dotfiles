return {
  "NStefan002/visual-surround.nvim",
  config = function()
    require("visual-surround").setup({
      -- surround selected text with "<>"
      vim.keymap.set("v", "<", function()
        require("visual-surround").surround("<")
      end)
    })
  end,
}
