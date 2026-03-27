local function focus_preview(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local picker = action_state.get_current_picker(prompt_bufnr)
  local prompt_win = picker.prompt_win
  local previewer = picker.previewer
  local bufnr = previewer.state.bufnr or previewer.state.termopen_bufnr
  local winid = previewer.state.winid or vim.fn.win_findbuf(bufnr)[1]
  vim.keymap.set("n", "<D-i>", function()
    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
  end, { buffer = bufnr })

  vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
  -- api.nvim_set_current_win(winid)
end


local live_multigrep = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd or vim.uv.cwd()

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  local make_entry = require("telescope.make_entry")

  local finder = finders.new_async_job({
    entry_maker = make_entry.gen_from_vimgrep(opts),
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local pieces = vim.split(prompt, "  ")
      local args = { "rg" }
      if pieces[1] then
        table.insert(args, "-e")
        table.insert(args, pieces[1])
      end
      if pieces[2] then
        table.insert(args, "-g")
        table.insert(args, pieces[2])
      end

      return vim.tbl_flatten({
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      })
    end,
  })

  pickers.new(opts, {
    debounce = 100,
    prompt_title = "Multi Grep",
    finder = finder,
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(),
  }):find()
end


return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
    },
    config = function()
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
          layout_config = {
            preview_cutoff = 1,
          },
          path_display = { "smart" },
          mappings = {
            n = {
              ["<D-i>"] = focus_preview,
              ["<C-k>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                for _ = 1, 5 do
                  actions.move_selection_previous(prompt_bufnr)
                end
              end,
              ["<C-j>"] = function(prompt_bufnr)
                local actions = require("telescope.actions")
                for _ = 1, 5 do
                  actions.move_selection_next(prompt_bufnr)
                end
              end,
            },
          },
          file_ignore_patterns = {
            ".git/",
            "node_modules/",
            "%.o",
            "%.a",
            "%.out",
            "%.pdf",
            "%.mkv",
            "%.mp4",
            "%.zip",
            ".cache",
            "dist",
            "coverage",
            "es5",
            "%.snap",
          },
        },
        preview = {
          filesize_limit = 0.5555,
          treesitter = true,
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          buffers = {
            initial_mode = "normal",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
          fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
          },
        },
      })

      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzy_native")

      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>p", builtin.find_files, {})
      -- vim.keymap.set("n", "<leader>/", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>b", builtin.buffers, {})
      vim.keymap.set("n", "<leader>/", live_multigrep, {})
    end,
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope-fzy-native.nvim",
    build = "make",
  },
}
