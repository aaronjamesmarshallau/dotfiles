return {
  "nvim-telescope/telescope.nvim",
  version = "*",
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function ()
    local telescope = require("telescope")
    telescope.setup({
      pickers = {
        find_files = {
          find_command = { "fd", "--color", "never", "--hidden" }
	      }
      }
    })
  end
}

