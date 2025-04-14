return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    local width = math.floor(vim.o.columns * 0.80)
    local height = math.floor(vim.o.lines * 0.80)

    require("toggleterm").setup({
      direction = "float",
      float_opts = {
        width = width,
        height = height,
        col = (vim.o.columns - width) / 2,
        row = (vim.o.lines - height) / 2,
        relative = 'editor',
        border = "curved",
      },
      start_in_insert = true
    })

    local Terminal = require("toggleterm.terminal").Terminal
    local term = Terminal:new({ hidden = true })
    local jira_term

    -- Pre-launch the terminal in the background
    term:open()
    term:close()

    function _toggle_term()
      term:toggle()
      vim.cmd("startinsert")
    end

    function _close_term()
      term:close()
    end

    function _close_jira_term()
      if jira_term then
        jira_term:close()
      end
    end

    vim.api.nvim_set_keymap("n", "<F12>", "<cmd>lua _toggle_term()<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("t", "<F12>", "<C-\\><C-n><cmd>lua _toggle_term()<CR>",
      { noremap = true, silent = true })

    vim.api.nvim_set_keymap("t", "<F2>", "<C-\\><C-n><cmd>lua _close_jira_term()<CR>", { noremap = true, silent = true })

    -- Call jira-cli with my current sprint
    vim.keymap.set("n", "<F2>", function()
      jira_term = Terminal:new({
        cmd = "jira sprint list --current -a$(jira me)",
      })
      jira_term:toggle()
    end, { noremap = true, silent = true })
  end
}
