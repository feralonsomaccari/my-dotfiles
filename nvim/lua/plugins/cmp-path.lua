return {
  'hrsh7th/nvim-cmp',
  config = function()
  end,
  'hrsh7th/cmp-path',
  cmp_path_config = function()
    cmp.setup({
      sources = {
        { name = 'nvim_lsp' },
        {
          name = 'cmp-path',
          keymap = {
            ['<CR>'] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true,
            }),
          }
        },
      },
    })
  end
}
