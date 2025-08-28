return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		local diffview = require("diffview")
		diffview.setup({
			default = {
				winbar_info = false,
			},
			file_panel = {
				listing_style = "list",
				win_config = {
					winbar = nil,
					tabline = nil,
				},
			},
			hooks = {
				view_opened = function(view)
					if view.left_file then
						for _, buf in ipairs(vim.api.nvim_list_bufs()) do
							local name = vim.api.nvim_buf_get_name(buf)
							if name:match(view.left_file) then
								vim.bo[buf].modifiable = false
								vim.bo[buf].readonly = true
							end
						end
					end
				end,
			},
		})

		vim.keymap.set("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>dh", "<cmd>DiffviewFileHistory<CR>", { noremap = true, silent = true })

		vim.keymap.set("n", "<C-w>[", "<C-w>h", { noremap = true, silent = true })
		vim.keymap.set("n", "<C-w>]", "<C-w>l", { noremap = true, silent = true })

	end,
}
