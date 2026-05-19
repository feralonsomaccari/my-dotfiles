return {
  "famiu/bufdelete.nvim",
  keys = {
    {
      "<Leader>q",
      function()
        require("bufdelete").bufdelete()
      end,
      mode = "n",
      silent = true,
    },
  },
}
