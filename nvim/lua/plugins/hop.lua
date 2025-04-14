return {
	'phaazon/hop.nvim',
	branch = 'v2',
	config = function()
		require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
		local hop = require('hop')
		local directions = require('hop.hint').HintDirection
		vim.api.nvim_set_keymap('', 'f', "<cmd>HopWord<CR>", {})
		vim.api.nvim_set_keymap('n', 't', "<cmd>HopPattern<CR>", {noremap = true})
	end
}
