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
vim.opt.clipboard:append("unnamedplus") -- Enable system clipboard support
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.o.cmdheight = 0 -- Hide the command line
vim.opt.fillchars = "eob: "
vim.opt.swapfile = false
vim.opt.incsearch = true -- Enable incremental search
vim.opt.cursorline = true -- Highlight the current line
vim.o.cursorlineopt = "number"
vim.g.loaded_netrwPlugin = 1 -- Disable netrw
vim.g.loaded_netrw = 1 -- Disable netrw
vim.o.laststatus = 2
vim.o.statusline = " %{substitute(system('git rev-parse --abbrev-ref HEAD'), '\\n', '', '')}"
	.. " %f %h%m%r"
	.. " %="
	.. " Last modified: %{substitute(system('git log -1 --date=format:%d/%m/%Y --format=\"%ad %an\" -- ' .. expand('%')), '\\n', '', '')} "
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

-- Define a custom function to toggle between Nvim-Tree and file window
function ToggleTreeFocus()
	local ft = vim.bo.filetype
	if ft == "NvimTree" or ft == "neo-tree" then
		vim.cmd("wincmd l")
	else
		vim.cmd("wincmd h")
	end
end

--[[
##################################################
#                MAPPINGS                        #
##################################################
]]
-- Map Ctrl+E to go to neo tree
vim.api.nvim_set_keymap("n", "<C-S-e>", ":lua ToggleTreeFocus()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-e>", ":lua ToggleTreeFocus()<CR>", { noremap = true, silent = true })

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
vim.api.nvim_set_keymap("n", "<C-l>", ":lua GoToPrevBuffer()<CR>", { noremap = true, silent = true })
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
vim.api.nvim_set_keymap(
	"v",
	"<leader>cl",
	[[:s/\("\?\w\+"\?\):\s*[^,}\n]\+/\1:/g<CR>]],
	{ noremap = true, silent = true }
) -- Clean values from objects

-- Disable keybidings that I don't use and are annoying
vim.api.nvim_set_keymap("i", "<C-j>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<C-k>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "K", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "J", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "K", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "J", "<Nop>", { noremap = true, silent = true })
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

--[[
##################################################
#                CUSTOM FUNCTIONS                #
##################################################
]]
-- Define a function to handle the cursor position
local function handle_search_cursor()
	-- If the search register is empty (no match), keep the cursor where it is
	if vim.fn.getreg("/") == "" or vim.v.hlsearch == 0 then
		-- If no match is found, we want to leave the cursor at its current position
		return
	end
end

-- Create an autocommand that listens to search events
vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = "/",
	callback = handle_search_cursor,
})

-- Function to check if the buffer is unnamed
function IsUnnamedBuffer(bufnr)
	return vim.fn.bufname(bufnr) == ""
end

-- Custom function for navigating to the previous buffer, skipping unnamed buffers
function GoToPrevBuffer()
	local buffers = vim.fn.getbufinfo({
		buflisted = 1,
	}) -- Only get listed buffers
	local current_buf = vim.fn.bufnr("%")
	local prev_buf = nil

	-- Find the current buffer in the list of buffers
	for i = #buffers, 1, -1 do
		if buffers[i].bufnr == current_buf then
			prev_buf = buffers[i - 1]
			break
		end
	end

	-- Skip unnamed buffers
	while prev_buf and IsUnnamedBuffer(prev_buf.bufnr) do
		for i = #buffers, 1, -1 do
			if buffers[i].bufnr == prev_buf.bufnr then
				prev_buf = buffers[i - 1]
				break
			end
		end
	end

	if prev_buf then
		vim.cmd("buffer " .. prev_buf.bufnr)
	end
end

-- Custom function for navigating to the next buffer, skipping unnamed buffers
function GoToNextBuffer()
	local buffers = vim.fn.getbufinfo({
		buflisted = 1,
	}) -- Only get listed buffers
	local current_buf = vim.fn.bufnr("%")
	local next_buf = nil

	-- Find the current buffer in the list of buffers
	for i = 1, #buffers do
		if buffers[i].bufnr == current_buf then
			next_buf = buffers[i + 1]
			break
		end
	end

	-- Skip unnamed buffers
	while next_buf and IsUnnamedBuffer(next_buf.bufnr) do
		for i = 1, #buffers do
			if buffers[i].bufnr == next_buf.bufnr then
				next_buf = buffers[i + 1]
				break
			end
		end
	end

	if next_buf then
		vim.cmd("buffer " .. next_buf.bufnr)
	end
end

-- Function to fetch Jira issue asynchronously
vim.g.jira_content = ""
vim.g.jira_popup_win = nil

function FetchJiraIssue()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD")
	local issue = branch:gsub("\n", "")

	-- Check if 'jira' command is available
	if vim.fn.executable("jira") == 1 then
		vim.fn.jobstart({ "jira", "issue", "view", issue, "--comments", "20" }, {
			stdout_buffered = true,
			on_stdout = function(_, data)
				vim.g.jira_content = table.concat(data, "\n")
			end,
			on_stderr = function(_, data)
				-- print("Error fetching Jira issue: " .. table.concat(data, "\n"))
			end,
		})
	else
		print("jira-cli is not installed.")
	end
end

vim.cmd([[autocmd VimEnter * lua FetchJiraIssue()]])

vim.api.nvim_set_keymap("n", "<F1>", ":lua ToggleJiraPopup()<CR>", {
	noremap = true,
	silent = true,
})

function ToggleJiraPopup()
	if vim.g.jira_popup_win and vim.api.nvim_win_is_valid(vim.g.jira_popup_win) then
		vim.api.nvim_win_close(vim.g.jira_popup_win, true)
		vim.g.jira_popup_win = nil
		return
	end
	OpenJiraInPopup(vim.g.jira_content)
end

function OpenJiraInPopup(content)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(content, "\n"))
	vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
	vim.api.nvim_buf_set_option(buf, "modifiable", true)
	vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		col = (vim.o.columns - width) / 2,
		row = (vim.o.lines - height) / 2,
		border = "rounded",
	}

	vim.g.jira_popup_win = vim.api.nvim_open_win(buf, true, opts)

	local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
	while #lines > 0 and vim.trim(lines[#lines]) == "" do
		lines[#lines] = nil
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})

	vim.api.nvim_chan_send(vim.api.nvim_open_term(buf, {}), table.concat(lines, "\r\n"))

	vim.api.nvim_command("highlight MyHighlightGroup1 guifg=#FF5A5A guibg=#2D2D2D")
	vim.api.nvim_command("syntax match MyHighlightGroup1 /`[^`]*`/")

	vim.api.nvim_command("highlight MyHighlightGroup2 guibg=#5050FF gui=bold")
	vim.api.nvim_command("syntax match MyHighlightGroup2 /#.*$/")

	vim.api.nvim_command("highlight MyHighlightGroup3 gui=bold")
	vim.api.nvim_command("syntax match MyHighlightGroup3 /\\*\\*[^*]*\\*\\*/")

	vim.api.nvim_command("highlight MyHighlightGroup5 gui=bold")
	vim.api.nvim_command("syntax match MyHighlightGroup5 /^.*•.*$/")

	vim.api.nvim_command("highlight MyHighlightGroup4 guifg=yellow guibg=blue gui=bold")
	vim.api.nvim_command("syntax match MyHighlightGroup4 /Latest comment/")

	vim.api.nvim_command("highlight MyHighlightGroup6 guifg=#009767")
	vim.api.nvim_command("syntax match MyHighlightGroup6 /\\(http\\|https\\):\\/\\/\\S\\+/")
end
