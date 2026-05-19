return {
  "ruifm/gitlinker.nvim",
  dependencies = 'nvim-lua/plenary.nvim',
  keys = {
    { "<leader>gy", mode = { "n", "v" } },
    { "<leader>gr" },
    { "<leader>gl" },
    { "<leader>gb" },
  },
  config = function()
    local gitlinker = require('gitlinker')
    local actions = require("gitlinker.actions")
    local hosts = require("gitlinker.hosts")

    gitlinker.setup({
      opts = {
        action_callback = actions.open_in_browser,
        remote = nil,
        add_current_line_on_normal_mode = false,
        mappings = nil,
      },
      callbacks = {
        ["github.dowjones.net"] = function(url_data)
          url_data.rev = "main"
          return hosts.get_github_type_url(url_data)
        end,
        ["github.com"] = function(url_data)
          url_data.rev = "main"
          return hosts.get_github_type_url(url_data)
        end,
      },
    })

    vim.keymap.set("n", "<leader>gy", function() gitlinker.get_buf_range_url('n') end,
      { noremap = true, silent = true, desc = "Get Git link for line" })
    vim.keymap.set("v", "<leader>gy", function() gitlinker.get_buf_range_url('v') end,
      { noremap = true, silent = true, desc = "Get Git link for range" })
    vim.keymap.set("n", "<leader>gr", "<cmd>lua require'gitlinker'.get_repo_url()<cr>", { silent = true })

    local function repo_url()
      local remote = vim.fn.systemlist({ "git", "config", "--get", "remote.origin.url" })[1] or ""
      -- Normalize git@host:owner/repo(.git) and https://host/owner/repo(.git) to https://host/owner/repo
      return remote
        :gsub("%.git$", "")
        :gsub("^git@([^:]+):", "https://%1/")
    end

    local function open_pr_for_file()
      local file = vim.api.nvim_buf_get_name(0)
      if file == "" then
        vim.notify("No file in buffer", vim.log.levels.WARN)
        return
      end
      local log = vim.fn.systemlist({ "git", "log", "-20", "--format=%s", "--", file })
      local pr
      for _, subject in ipairs(log) do
        pr = subject:match("#(%d+)")
        if pr then break end
      end
      if not pr then
        vim.notify("No PR found for this file", vim.log.levels.INFO)
        return
      end
      local url = repo_url()
      if url == "" then
        vim.notify("No remote.origin.url configured", vim.log.levels.WARN)
        return
      end
      vim.ui.open(url .. "/pull/" .. pr)
    end

    local function open_pr_for_line()
      local file = vim.api.nvim_buf_get_name(0)
      if file == "" then
        vim.notify("No file in buffer", vim.log.levels.WARN)
        return
      end
      local line = vim.api.nvim_win_get_cursor(0)[1]
      local blame = vim.fn.systemlist({
        "git", "blame", "-L", line .. "," .. line, "--porcelain", "--", file,
      })
      if vim.v.shell_error ~= 0 or not blame[1] then
        vim.notify("git blame failed for this line", vim.log.levels.WARN)
        return
      end
      local sha = blame[1]:match("^(%x+)")
      if not sha or sha:match("^0+$") then
        vim.notify("Line is uncommitted", vim.log.levels.INFO)
        return
      end
      local subject = vim.fn.systemlist({ "git", "log", "-1", "--format=%s", sha })[1] or ""
      local pr = subject:match("#(%d+)")
      if not pr then
        vim.notify("No PR found for this line", vim.log.levels.INFO)
        return
      end
      local url = repo_url()
      if url == "" then
        vim.notify("No remote.origin.url configured", vim.log.levels.WARN)
        return
      end
      vim.ui.open(url .. "/pull/" .. pr)
    end

    vim.keymap.set("n", "<leader>gl", open_pr_for_file,
      { noremap = true, silent = true, desc = "Open PR for current file in browser" })
    vim.keymap.set("n", "<leader>gb", open_pr_for_line,
      { noremap = true, silent = true, desc = "Open PR for current line in browser" })
  end,
}
