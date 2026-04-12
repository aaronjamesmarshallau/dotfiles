return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    local treesitter = require("nvim-treesitter")
    local ensureInstalled = {
        "c", "cpp", "lua", "vim", "vimdoc", "c_sharp", "typescript", "javascript", "python", "java", "kotlin", "json", "yaml", "html", "css", "nix"
    }

    treesitter.install(ensureInstalled)

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
	-- Enable treesitter-based highlighting, disable default regex-based
	local lang = vim.treesitter.language.get_lang(args.match)
	if lang and vim.treesitter.language.add(lang) then
	  vim.treesitter.start()
	end
	-- Use nvim-treesitter for indentation
	vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end
}

