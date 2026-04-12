local whichKey = require("which-key")
local telescope = require("telescope.builtin")

whichKey.add({
  {
    group = "which-key",
    { "<leader>?", function () whichKey.show({ global = false }) end, desc = "Show keymap" },
  },
  {
    group = "telescope",
    mode = { "n", "v" },
    { "<leader>ff", telescope.find_files, desc = "Open file finder" },
    { "<leader>fg", telescope.live_grep, desc = "Open file finder in grep mode" },
  },
  {
    group = "nvim",	
    { "<leader>q", "<cmd>q<cr>", desc = "Quit", mode = { "n", "v" } },
    { "<leader>w", "<cmd>w<cr>", desc = "Save", mode = { "n", "v" } },
    { "<leader>e", vim.cmd.Ex, desc = "Open netrw in current directory", mode = { "n", "v" } },
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  -- helps with dynamically created groups
  group = vim.api.nvim_create_augroup('user_lsp_attach', { clear = true }),
  callback = function(event)
    local opts = { buffer = event.buf }

    whichKey.add({
      { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
      { "gl", vim.diagnostic.open_float, desc = "Open diagnostic float" },
      { "K", vim.lsp.buf.hover, desc = "Show hover information" },
      { "<leader>la", vim.lsp.buf.code_action, desc = "Code context action" },
      { "<leader>lr", vim.lsp.buf.references, desc = "Show references" },
      { "<leader>ln", vim.lsp.buf.rename, desc = "Rename" },
      { "<leader>ls", vim.lsp.buf.workspace_symbol, desc = "Search for symbol in workspace" },
      { "<leader>ld", vim.diagnostic.open_float, desc = "Open diagnostic float" },
      { "d[", vim.diagnostic.goto_prev, desc = "Go to previous diagnostic" },
      { "d]", vim.diagnostic.goto_next, desc = "Go to next diagnostic" },
    })
  end,
})

