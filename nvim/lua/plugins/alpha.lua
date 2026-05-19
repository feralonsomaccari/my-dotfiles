return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.startify")
    dashboard.nvim_web_devicons.enabled = false
    dashboard.section.mru.val = { { type = "padding", val = 0 } }
    dashboard.section.header.val = {}
    dashboard.section.top_buttons.val = {}
    dashboard.section.bottom_buttons.val = {}

    -- Replace "MRU <full path>" title with the project (cwd) name as ASCII art
    local font = {
      ["a"] = { " ▄▀█ ", " █▀█ ", "     " },
      ["b"] = { " █▄▄ ", " █▄█ ", "     " },
      ["c"] = { " █▀▀ ", " █▄▄ ", "     " },
      ["d"] = { " █▀▄ ", " █▄▀ ", "     " },
      ["e"] = { " █▀▀ ", " ██▄ ", "     " },
      ["f"] = { " █▀▀ ", " █▀  ", "     " },
      ["g"] = { " █▀▀ ", " █▄█ ", "     " },
      ["h"] = { " █ █ ", " █▀█ ", "     " },
      ["i"] = { " █ ", " █ ", "   " },
      ["j"] = { "   █ ", " █▄█ ", "     " },
      ["k"] = { " █▄▀ ", " █ █ ", "     " },
      ["l"] = { " █   ", " █▄▄ ", "     " },
      ["m"] = { " █▀▄▀█ ", " █ ▀ █ ", "       " },
      ["n"] = { " █▄ █ ", " █ ▀█ ", "      " },
      ["o"] = { " █▀█ ", " █▄█ ", "     " },
      ["p"] = { " █▀█ ", " █▀  ", "     " },
      ["q"] = { " █▀█ ", " ▀▀█ ", "     " },
      ["r"] = { " █▀█ ", " █▀▄ ", "     " },
      ["s"] = { " █▀ ", " ▄█ ", "    " },
      ["t"] = { " ▀█▀ ", "  █  ", "     " },
      ["u"] = { " █ █ ", " █▄█ ", "     " },
      ["v"] = { " █ █ ", " ▀▄▀ ", "     " },
      ["w"] = { " █ █ █ ", " ▀▄▀▄▀ ", "       " },
      ["x"] = { " ▀▄▀ ", " █ █ ", "     " },
      ["y"] = { " █▄█ ", "  █  ", "     " },
      ["z"] = { " ▀▀█ ", " █▄▄ ", "     " },
      ["0"] = { " █▀█ ", " █▄█ ", "     " },
      ["1"] = { " ▄█ ", "  █ ", "    " },
      ["2"] = { " ▀█ ", " █▄ ", "    " },
      ["3"] = { " ▀█ ", " ▄█ ", "    " },
      ["4"] = { " █▄█ ", "   █ ", "     " },
      ["5"] = { " █▀ ", " ▄█ ", "    " },
      ["6"] = { " █▄ ", " █▄█ ", "     " },
      ["7"] = { " ▀█ ", "  █ ", "    " },
      ["8"] = { " █▀█ ", " █▀█ ", "     " },
      ["9"] = { " █▀█ ", "  ▄█ ", "     " },
      ["-"] = { "     ", " ▄▄▄ ", "     " },
      ["_"] = { "     ", " ▄▄▄ ", "     " },
      ["."] = { "   ", " █ ", "   " },
      [" "] = { "   ", "   ", "   " },
    }

    local function ascii_art(text)
      text = text:lower()
      local lines = { "", "", "" }
      for i = 1, #text do
        local ch = text:sub(i, i)
        local glyph = font[ch] or font[" "]
        for row = 1, 3 do
          lines[row] = lines[row] .. glyph[row]
        end
      end
      return lines
    end

    dashboard.section.mru_cwd.val[2] = {
      type = "text",
      val = ascii_art(vim.fn.fnamemodify(vim.fn.getcwd(), ":t")),
      opts = { hl = "Constant", shrink_margin = false, position = "left" },
    }

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "BDeletePost*",
      callback = function(event)
        local fallback_name = vim.api.nvim_buf_get_name(event.buf)
        local fallback_ft = vim.api.nvim_get_option_value("filetype", { buf = event.buf })
        local fallback_on_empty = fallback_name == "" and fallback_ft == ""

        if fallback_on_empty then
          require("alpha").start(false)
        end
      end,
    })

    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function()
        local bufs = vim.tbl_filter(function(b)
          return vim.api.nvim_buf_is_valid(b)
            and vim.api.nvim_buf_get_option(b, "buflisted")
        end, vim.api.nvim_list_bufs())

        if #bufs <= 1 then
          vim.defer_fn(function()
            local buf = vim.api.nvim_get_current_buf()
            local name = vim.api.nvim_buf_get_name(buf)
            local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
            if name == "" and ft == "" then
              require("alpha").start(false)
            end
          end, 0)
        end
      end,
    })
  end,
}
