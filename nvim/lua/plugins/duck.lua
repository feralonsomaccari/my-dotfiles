return {
    'tamton-aquib/duck.nvim',
    config = function()
        vim.keymap.set('n', '<leader>vi', function() require("duck").hatch() end, {})
        vim.keymap.set('n', '<leader>vo', function() require("duck").cook_all() end, {})
    end
}
