return {
  "tamton-aquib/duck.nvim",
  keys = {
    { "<leader>vi", function() require("duck").hatch() end, mode = "n" },
    { "<leader>vo", function() require("duck").cook_all() end, mode = "n" },
  },
}
