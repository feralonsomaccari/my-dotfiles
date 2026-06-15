--[[
##################################################
#         STATUSLINE: LAST MODIFIED              #
##################################################
]]
-- Cache `git log` per buffer to avoid shelling out on every redraw.
-- Reads the last 20 commits touching the file: first line gives date/author,
-- and any subject containing `#<num>` provides the most recent merged PR.
local function update_last_modified(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local file = vim.api.nvim_buf_get_name(bufnr)
	if file == "" or not vim.bo[bufnr].buflisted then
		return
	end
	vim.fn.jobstart(
		{ "git", "log", "-20", "--date=format:%d/%m/%Y", "--format=%ad%x09%an%x09%s", "--", file },
		{
			stdout_buffered = true,
			on_stdout = function(_, data)
				if not vim.api.nvim_buf_is_valid(bufnr) then
					return
				end
				if not data or not data[1] or data[1] == "" then
					vim.b[bufnr].statusline_last_modified = ""
					return
				end
				local date, author = data[1]:match("^([^\t]+)\t([^\t]+)\t")
				local line = date and ("Last modified: " .. date .. " " .. author) or ""
				for _, commit in ipairs(data) do
					local pr = commit:match("#(%d+)")
					if pr then
						line = line .. " (#" .. pr .. ")"
						break
					end
				end
				vim.b[bufnr].statusline_last_modified = line
				vim.schedule(function()
					vim.cmd("redrawstatus")
				end)
			end,
		}
	)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function(args)
		update_last_modified(args.buf)
	end,
})

--[[
##################################################
#         SEARCH CURSOR HANDLER                  #
##################################################
]]
local function handle_search_cursor()
	-- If the search register is empty (no match), keep the cursor where it is
	if vim.fn.getreg("/") == "" or vim.v.hlsearch == 0 then
		return
	end
end

vim.api.nvim_create_autocmd("CmdlineChanged", {
	pattern = "/",
	callback = handle_search_cursor,
})

--[[
##################################################
#         BUFFER NAVIGATION                      #
##################################################
]]
function IsUnnamedBuffer(bufnr)
	return vim.fn.bufname(bufnr) == ""
end

function GoToPrevBuffer()
	local buffers = vim.fn.getbufinfo({
		buflisted = 1,
	})
	local current_buf = vim.fn.bufnr("%")
	local prev_buf = nil

	for i = #buffers, 1, -1 do
		if buffers[i].bufnr == current_buf then
			prev_buf = buffers[i - 1]
			break
		end
	end

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

function GoToNextBuffer()
	local buffers = vim.fn.getbufinfo({
		buflisted = 1,
	})
	local current_buf = vim.fn.bufnr("%")
	local next_buf = nil

	for i = 1, #buffers do
		if buffers[i].bufnr == current_buf then
			next_buf = buffers[i + 1]
			break
		end
	end

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

--[[
##################################################
#         JIRA ISSUE POPUP                       #
##################################################
]]
-- Uses ankitpokhrel/jira-cli with --plain so render-markdown styles the buffer.
-- Assumes the current branch name is a Jira issue key (e.g. PROJ-123 or PROJ-123-some-description).
vim.g.jira_content = ""
vim.g.jira_popup_win = nil

function FetchJiraIssue()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
	local issue = branch:match("^[A-Z]+%-%d+")
	if not issue then
		return
	end

	if vim.fn.executable("jira") == 1 then
		vim.fn.jobstart({ "jira", "issue", "view", issue, "--plain", "--comments", "20" }, {
			stdout_buffered = true,
			on_stdout = function(_, data)
				local kept = {}
				for _, line in ipairs(data) do
					-- Drop the trailing "View this issue on Jira: ..." footer line.
					if not line:match("View this issue on Jira:") then
						table.insert(kept, line)
					end
				end
				-- Strip residual ANSI escape sequences (jira-cli leaks them on some lines even with --plain).
				local content = table.concat(kept, "\n")
				content = content:gsub("\27%[[%d;]*m", "")
				vim.g.jira_content = content
			end,
		})
	else
		print("jira-cli is not installed.")
	end
end

vim.api.nvim_create_autocmd("VimEnter", { callback = FetchJiraIssue })

-- Link Jira comment groups to theme groups so colours follow the active colorscheme.
local function set_jira_highlights()
	vim.api.nvim_set_hl(0, "JiraCommentHeader", { link = "Title" })
	vim.api.nvim_set_hl(0, "JiraCommentBody", { link = "Comment" })
	vim.api.nvim_set_hl(0, "JiraMention", { link = "@markup.link" })
	vim.api.nvim_set_hl(0, "JiraUrl", { link = "@markup.link.url" })
	vim.api.nvim_set_hl(0, "JiraSection", { link = "@markup.heading.2" })
end
set_jira_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_jira_highlights })

function OpenJiraInPopup(content)
	local lines = vim.split(content, "\n")
	while #lines > 0 and vim.trim(lines[#lines]) == "" do
		lines[#lines] = nil
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "markdown"
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].readonly = true

	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	vim.g.jira_popup_win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = (vim.o.columns - width) / 2,
		row = (vim.o.lines - height) / 2,
		border = "rounded",
	})
	vim.wo[vim.g.jira_popup_win].number = false
	vim.wo[vim.g.jira_popup_win].relativenumber = false
	vim.wo[vim.g.jira_popup_win].signcolumn = "no"

	-- If the buffer is closed (e.g. via <leader>q / :bd), tear down the floating window too.
	vim.api.nvim_create_autocmd({ "BufWipeout", "BufUnload" }, {
		buffer = buf,
		once = true,
		callback = function()
			if vim.g.jira_popup_win and vim.api.nvim_win_is_valid(vim.g.jira_popup_win) then
				pcall(vim.api.nvim_win_close, vim.g.jira_popup_win, true)
			end
			vim.g.jira_popup_win = nil
		end,
	})

	-- Section dividers: `---- Name ----`
	vim.cmd([[syntax match JiraSection /^\s*-\{3,}\s\+\S.*\S\s\+-\{3,}\s*$/]])
	-- Highlight comment headers (lines containing ` • `) and tint the body lines that follow.
	vim.cmd([[syntax match JiraCommentHeader /^.*•.*$/ contains=@NoSpell]])
	vim.cmd([[syntax match JiraMention /@@\S\+/ containedin=ALL]])
	-- Single-@ mentions: only when preceded by whitespace/start-of-line (avoids matching emails).
	vim.cmd([[syntax match JiraMention /\(^\|\s\)\zs@\w\+/ containedin=ALL]])
	vim.cmd([[syntax match JiraUrl /\(http\|https\):\/\/\S\+/ containedin=ALL]])
	vim.cmd([[syntax region JiraCommentBody start=/^.*•.*$/ms=e+1 end=/^.*•.*$/me=s-1 contains=JiraCommentHeader,JiraMention,JiraUrl keepend]])
end

function ToggleJiraPopup()
	if vim.g.jira_popup_win and vim.api.nvim_win_is_valid(vim.g.jira_popup_win) then
		vim.api.nvim_win_close(vim.g.jira_popup_win, true)
		vim.g.jira_popup_win = nil
		return
	end
	if vim.g.jira_content == "" then
		FetchJiraIssue()
		vim.notify("Fetching Jira issue... try again in a moment.", vim.log.levels.INFO)
		return
	end
	OpenJiraInPopup(vim.g.jira_content)
end

vim.keymap.set("n", "<leader>jt", ToggleJiraPopup,
	{ noremap = true, silent = true, desc = "Toggle Jira issue popup" })

-- Open the current branch's Jira issue in the browser.
-- Reads server URL from ~/.config/.jira/.config.yml (or $JIRA_CONFIG_FILE).
local function open_jira_issue()
	local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("\n", "")
	local issue = branch:match("^[A-Z]+%-%d+")
	if not issue then
		vim.notify("Current branch is not a Jira issue key", vim.log.levels.WARN)
		return
	end
	local config_path = vim.env.JIRA_CONFIG_FILE or (vim.env.HOME .. "/.config/.jira/.config.yml")
	local server
	for line in io.lines(config_path) do
		server = line:match("^server:%s*[\"']?([^\"'%s]+)")
		if server then break end
	end
	if not server then
		vim.notify("Could not read server URL from " .. config_path, vim.log.levels.WARN)
		return
	end
	vim.ui.open(server .. "/browse/" .. issue)
end

vim.keymap.set("n", "<leader>jo", open_jira_issue,
	{ noremap = true, silent = true, desc = "Open Jira issue in browser" })
