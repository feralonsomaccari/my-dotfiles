return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  opts = {
    -- Minimal: conceal raw markers, color headings, leave bullets and checkboxes alone.
    win_options = {
      concealcursor = { rendered = "nvc" },
    },
    heading = {
      sign = false,
      icons = {},
      width = "block",
    },
    bullet = { enabled = false },
    checkbox = { enabled = false },
    code = {
      sign = false,
      width = "block",
      border = "thin",
    },
    quote = { repeat_linebreak = true },
  },
}
