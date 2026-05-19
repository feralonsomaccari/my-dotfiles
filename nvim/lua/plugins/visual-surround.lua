return {
  "NStefan002/visual-surround.nvim",
  keys = {
    { "<", function() require("visual-surround").surround("<") end, mode = "v" },
  },
  config = function()
    require("visual-surround").setup({})
  end,
}
