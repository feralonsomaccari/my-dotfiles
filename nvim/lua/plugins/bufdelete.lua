local deleted_buffers = {}

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function(args)
    if args.file ~= "" and vim.fn.filereadable(args.file) == 1 then
      table.insert(deleted_buffers, args.file)
    end
  end,
})

return {
  "famiu/bufdelete.nvim",
  keys = {
    {
      "<Leader>q",
      function()
        require("bufdelete").bufdelete()
      end,
      mode = "n",
      silent = true,
    },
    {
      "<Leader>w",
      function()
        local file = table.remove(deleted_buffers)
        if file then
          vim.cmd("edit " .. vim.fn.fnameescape(file))
        else
          vim.notify("No deleted buffers to restore", vim.log.levels.INFO)
        end
      end,
      mode = "n",
      silent = true,
    },
  },
}
