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
#         BROWSER-STYLE BUFFER HISTORY           #
##################################################
]]
-- Each window keeps its own stack and cursor in vim.w.
local function is_unnamed(bufnr)
	return vim.fn.bufname(bufnr) == ""
end

local function init_history()
	if not vim.w.buf_history then
		vim.w.buf_history = { vim.api.nvim_get_current_buf() }
		vim.w.buf_history_idx = 1
		vim.w.buf_history_navigating = false
	end
end

local function go_in_history(direction)
	init_history()
	local hist = vim.w.buf_history
	local idx = vim.w.buf_history_idx
	local target_idx = idx + direction
	while target_idx >= 1 and target_idx <= #hist do
		local target = hist[target_idx]
		if target and vim.api.nvim_buf_is_valid(target) and vim.fn.buflisted(target) == 1 then
			vim.w.buf_history_navigating = true
			vim.cmd("buffer " .. target)
			vim.w.buf_history_idx = target_idx
			return
		end
		target_idx = target_idx + direction
	end
end

function GoToPrevBuffer()
	go_in_history(-1)
end

function GoToNextBuffer()
	go_in_history(1)
end

vim.api.nvim_create_autocmd("BufEnter", {
	callback = function()
		local cur = vim.api.nvim_get_current_buf()
		if is_unnamed(cur) or vim.bo.buflisted == false then return end
		init_history()
		if vim.w.buf_history_navigating then
			vim.w.buf_history_navigating = false
			return
		end
		local hist = vim.w.buf_history
		local idx = vim.w.buf_history_idx
		if hist[idx] == cur then return end
		for i = #hist, idx + 1, -1 do
			table.remove(hist, i)
		end
		table.insert(hist, cur)
		vim.w.buf_history = hist
		vim.w.buf_history_idx = #hist
	end,
})

-- Prune deleted buffers from every window's history stack.
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
	callback = function(args)
		local dying = args.buf
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local hist = vim.w[win].buf_history
			if hist then
				local idx = vim.w[win].buf_history_idx or 1
				local new_hist, new_idx = {}, idx
				for i, b in ipairs(hist) do
					if b ~= dying then
						table.insert(new_hist, b)
					elseif i < idx then
						new_idx = new_idx - 1
					end
				end
				if new_idx > #new_hist then new_idx = #new_hist end
				if new_idx < 1 then new_idx = 1 end
				vim.w[win].buf_history = new_hist
				vim.w[win].buf_history_idx = new_idx
			end
		end
	end,
})
