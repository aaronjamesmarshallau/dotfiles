return {
  -- Premade LSP Configs
  {
    "neovim/nvim-lspconfig",
    dependencies = { 'saghen/blink.cmp' },
    config = function ()
      vim.lsp.enable("clangd")
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("nil_ls")
    end,
  },
}

