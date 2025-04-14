return {
  'brenoprata10/nvim-highlight-colors',
  config = function()
    require("nvim-highlight-colors").setup({
      enable_named_colors = true, -- Enable named colors like 'red', 'blue', etc.
      enable_rgb = true,          -- Enable RGB colors like rgb(255, 0, 0)
      enable_hex = true,          -- Enable hex codes like #ff5733
      enable_hsl = true,          -- Enable HSL colors like hsl(360, 100%, 50%)
    })
  end,
}
