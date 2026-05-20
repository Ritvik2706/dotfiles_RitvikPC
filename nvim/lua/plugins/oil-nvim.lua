-- https://github.com/stevearc/oil.nvim
-- Use `-` to open; supports SSH: `nvim oil-ssh://host//path`
return {
  "stevearc/oil.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Open parent directory" },
  },
}
