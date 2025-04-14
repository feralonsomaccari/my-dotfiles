return {
  'famiu/bufdelete.nvim',
  config = function()
    vim.keymap.set('n', '<Leader>q', function() require('bufdelete').bufdelete(0, true) end, { noremap = true, silent = true })
  end,
}
