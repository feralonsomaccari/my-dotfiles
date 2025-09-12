return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
	config = function()
		vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>", { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>fr", ":Neotree reveal<CR>:Neotree focus<CR>", { noremap = true, silent = true })

		require("neo-tree").setup({
			enable_diagnostics = false,
			sources = { "filesystem", "git_status" },
			filesystem = {
				filtered_items = { visible = true },
				hijack_netrw_behavior = "disabled",
			},
			close_if_last_window = true,
			source_selector = { winbar = false },
			disabled_filetypes = { "packer", "NVimTree" },
			git_status = { sort_untracked_first = true },
			default_component_configs = {
				icon = {
					enabled = true,
					provider = function(icon, node)
						if node.type == "file" or node.type == "terminal" then
							local success, web_devicons = pcall(require, "nvim-web-devicons")
							if success then
								local devicon =
									web_devicons.get_icon(node.type == "terminal" and "terminal" or node.name)
								icon.text = devicon or icon.text
								icon.highlight = "NeoTreeFileIcon"
							end
						end
					end,
					highlight = "NeoTreeFileIcon",
				},
				indent = {
					with_markers = false,
					indent_marker = "",
					last_indent_marker = "",
					expander_collapsed = "",
					expander_expanded = "",
				},
				git_status = {
					symbols = {
						added = "a",
						modified = "m",
						deleted = "x",
						renamed = "r",
						untracked = "u",
						ignored = "",
						unstaged = "U",
						staged = "s",
						conflict = "c",
					},
				},
				diagnostics = {
					symbols = { hint = "", info = "", warn = "W", error = "E" },
				},
			},
			buffers = { follow_current_file = { enabled = true } },
			window = {
				position = "current",
				title = "",
				mappings = {
					["f"] = "",
					["<leader>fp"] = function(state)
						local node = state.tree:get_node()
						if node then
							local cwd = node.type == "directory" and node.path or vim.fn.fnamemodify(node.path, ":h")
							require("telescope.builtin").find_files({ cwd = cwd })
						end
					end,
					["<leader>f/"] = function(state)
						local node = state.tree:get_node()
						if node then
							local cwd = node.type == "directory" and node.path or vim.fn.fnamemodify(node.path, ":h")
							require("telescope.builtin").live_grep({ cwd = cwd })
						end
					end,
				},
			},
		})
	end,
}
