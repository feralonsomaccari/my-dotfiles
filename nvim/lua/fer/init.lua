--[[
##################################################
#                OPTIONS CONFIGURATION           #
##################################################
]]
vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.termguicolors = true
vim.o.signcolumn = "yes" -- keep "space" for git sign lines
vim.o.ignorecase = true -- Ignore case in searches
vim.o.smartcase = true -- Use case sensitivity when uppercase letters are used in the search pattern
vim.schedule(function()
	vim.opt.clipboard:append("unnamedplus") -- Enable system clipboard support (lazy to skip startup probe)
end)
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.o.cmdheight = 0 -- Hide the command line
vim.opt.fillchars = "eob: "
vim.opt.swapfile = false
vim.opt.incsearch = true -- Enable incremental search
vim.opt.cursorline = true -- Highlight the current line
vim.o.cursorlineopt = "number"
vim.g.loaded_netrwPlugin = 1 -- Disable netrw
vim.g.loaded_netrw = 1 -- Disable netrw
vim.o.showtabline = 0 -- Disable tabs
vim.o.laststatus = 2
vim.o.statusline = "  [%{get(b:,'gitsigns_head','')}]"
	.. " %{fnamemodify(getcwd(), ':t') . '/' . expand('%:p:.')} %h%m%r"
	.. " %="
	.. " %#LineNr#%{get(b:,'statusline_last_modified','')} "

vim.opt.diffopt =
	{ "internal", "filler", "closeoff", "context:12", "algorithm:histogram", "linematch:200", "indent-heuristic" }

--[[
##################################################
#                CUSTOM COMMANDS                 #
##################################################
]]
-- Stop auto-comenting in a new line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.cmd([[
let g:closetag_filenames = '*.html,*.xhtml,*.jsx,*.tsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'
let g:closetag_filetypes = 'html,js'
let g:closetag_xhtml_filetype = 'xhtml,jsx,tsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_regions = {
\ 'typescript.tsx': 'jsxRegion,tsxRegion',
\ 'javascript.jsx': 'jsxRegion',
\ }
let g:closetag_shortcut = '>'
]])

-- Highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]])

--[[
##################################################
#                MAPPINGS                        #
##################################################
]]

-- Remap Ctrl+J to behave like Ctrl+D (half-page down) in normal and visual modes
vim.api.nvim_set_keymap("n", "<C-j>", "5j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-j>", "5j", { noremap = true, silent = true })
-- Remap Ctrl+K to behave like Ctrl+U (half-page up) in normal and visual modes
vim.api.nvim_set_keymap("n", "<C-k>", "5k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-k>", "5k", { noremap = true, silent = true })

-- Delete words with CTRL + backspace
vim.api.nvim_set_keymap("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })

-- Delete to blackhole register
vim.api.nvim_set_keymap("n", "dd", '"_dd', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "d", '"_d', { noremap = true, silent = true })
-- Delete in normal register
vim.api.nvim_set_keymap("n", "dc", "dd", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "dc", "_d", { noremap = true, silent = true })

-- Normal mode mapping for <C-a> to select everything in the file
vim.api.nvim_set_keymap("n", "<D-a>", "ggVG", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-a>", "ggVG", { noremap = true, silent = true })

-- Explicitly map <Esc> to ensure it works
vim.api.nvim_set_keymap("i", "<Esc>", "<Esc>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<Esc>", "<Esc>", { noremap = true, silent = true })

-- Change search function to prevent getting moved back after pressing ESC
vim.api.nvim_set_keymap("c", "<ESC>", "<CR>", { noremap = true, silent = true })

-- Map gg to gg0 to move the cursor to the beginning (first character) of the file intead of top
vim.api.nvim_set_keymap("n", "gg", "gg0", { noremap = true, silent = true })

-- Chabge CTRL + [ and ] as history
vim.api.nvim_set_keymap("n", "<C-h>", ":lua GoToPrevBuffer()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", ":lua GoToNextBuffer()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-[>", ":lua GoToPrevBuffer()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-]>", ":lua GoToNextBuffer()<CR>", { noremap = true, silent = true })

-- Move line up with Shift+K or Shift+J
vim.api.nvim_set_keymap("n", "K", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "J", ":m .+1<CR>==", { noremap = true, silent = true })
-- Move selected block (Visual mode) with Shift+K or Shift+J
vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Cuts without saving to clipboard
vim.api.nvim_set_keymap("x", "p", '"_dP', { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "y", "ygv<Esc>", { noremap = true, silent = true })

-- Map the custom paste function in Visual mode and Normal Mode
vim.api.nvim_set_keymap("n", "<leader>fn", ":let @/ = expand('<cword>')<CR>n", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>fn", "y/<C-R><C-O>0<CR>", { noremap = true, silent = true })

-- Make shift+V to select from the cursor to the end of the line without creating a new line when cutting
vim.api.nvim_set_keymap("n", "V", "0v$h", { noremap = true, silent = true })

-- Modify shift+G to also put the cursor in last character in viusual mode and normal mode
vim.api.nvim_set_keymap("x", "G", "G$", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "G", "G$", { noremap = true, silent = true })

-- Column mode to ctrl+q
vim.api.nvim_set_keymap("v", "<C-v>", "<C-w><C-v>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<D-v>", "<C-w><C-v>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<C-q>', '<C-w><C-v>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<D-q>', '<C-w><C-v>', { noremap = true, silent = true })

-- Improves Esc to also remove highlighting on search
vim.api.nvim_set_keymap("n", "<Esc>", "<Esc>:noh<CR>", { noremap = true, silent = true })

-- Custom utils
vim.api.nvim_set_keymap("v", "<leader>ck", [[:s/"\(\w\+\)":/\1:/g<CR>]], { noremap = true, silent = true }) -- Custom regex to clean quotes marks quotes from objects
vim.api.nvim_set_keymap("v", "<leader>cl", [[:s/\("\?\w\+"\?\):\s*[^,}\n]\+/\1:/g<CR>]], { noremap = true, silent = true } ) -- Clean values from objects
vim.api.nvim_set_keymap("v", "<leader>cs", ":'<,'>sort<CR>", { noremap = true, silent = true } ) -- Sort props alphabetically

-- Disable keybidings that I don't use and are annoying
vim.api.nvim_set_keymap("i", "<C-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<Nop>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-z>', '<Nop>', { noremap = true, silent = true })

-- Switch booleans, lowercase/uppercase and increase/decrease numbers (also works with css units like 30px or 2rem)
vim.keymap.set("n", "`", function()
	local word = vim.fn.expand("<cword>")
	local num, unit = word:match("([%d%.]+)(%a*)")
	num = tonumber(num)

	if word == "true" then
		vim.cmd("normal! ciwfalse")
	elseif word == "false" then
		vim.cmd("normal! ciwtrue")
	elseif num then
		vim.cmd("normal! ciw" .. (num + 1) .. unit)
	else
		if word:lower() == word then
			vim.cmd("normal! viwU")
		else
			vim.cmd("normal! viwu")
		end
	end
end, {
	noremap = true,
	silent = true,
})

-- Capitalize and decrease number
vim.keymap.set("n", "~", function()
	local word = vim.fn.expand("<cword>")
	local num, unit = word:match("([%d%.]+)(%a*)")
	num = tonumber(num)

	if num then
		vim.cmd("normal! ciw" .. (num - 1) .. unit)
	else
		local capitalized_word = word:sub(1, 1):upper() .. word:sub(2):lower()
		vim.cmd("normal! ciw" .. capitalized_word)
	end
end, {
	noremap = true,
	silent = true,
})

require("fer.functions")
