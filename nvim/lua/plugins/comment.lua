return {
  'numToStr/Comment.nvim',
  dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
  config = function()
    require('Comment').setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })

    vim.keymap.set("n", "<C-/>", function() require('Comment.api').toggle.linewise.current() end,
      { noremap = true, silent = true })
    vim.keymap.set("v", "<C-/>", function() require('Comment.api').toggle.linewise.current() end,
      { noremap = true, silent = true })

  end,

  -- Note: use gc and gb
}
