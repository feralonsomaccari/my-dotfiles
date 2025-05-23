return {
  'numToStr/Comment.nvim',
  dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
  config = function()
    require('Comment').setup({
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    })

    -- For normal mode to toggle comment
    vim.keymap.set("n", "<C-_>", function()
      require('Comment.api').toggle.linewise.current()
    end, { noremap = true, silent = true })

    -- For visual mode to toggle comment
    vim.keymap.set("v", "<C-_>", function()
      local esc = vim.api.nvim_replace_termcodes('<ESC>', true, false, true)
      vim.api.nvim_feedkeys(esc, 'nx', false)
      require('Comment.api').toggle.linewise(vim.fn.visualmode())
    end, { noremap = true, silent = true })
  end,
}

