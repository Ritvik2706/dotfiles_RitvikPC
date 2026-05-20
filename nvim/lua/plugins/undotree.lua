-- https://github.com/mbbill/undotree
-- Visualise Neovim's undo tree as a sidebar.
-- LazyVim already enables undofile so history persists across restarts —
-- undotree lets you navigate it visually, including branches where you
-- typed something, undid it, then typed something else.
--
-- Keymap: <leader>u  toggle the sidebar (focus jumps into it automatically)
return {
  "mbbill/undotree",
  cmd  = "UndotreeToggle",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle undo tree" },
  },
  init = function()
    vim.g.undotree_WindowLayout       = 2  -- tree left, diff below-right
    vim.g.undotree_SplitWidth         = 35
    vim.g.undotree_SetFocusWhenToggle = 1  -- jump into tree on open
    vim.g.undotree_ShortIndicators    = 1  -- compact time labels
  end,
}
