return {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    require("nvim-highlight-colors").setup({
      enable_named_colors = true,
      enable_rgb = true,
      enable_hex = true,
      enable_hsl = true,
    })
  end,
}
