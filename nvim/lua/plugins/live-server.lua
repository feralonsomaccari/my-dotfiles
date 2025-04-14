return {
  {
    'wolandark/vim-live-server',
    build = function()
      vim.fn.system('sudo npm install -g live-server')
      vim.fn.system('sudo npm install -g browser-sync')
    end,
  },
}
