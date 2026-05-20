-- https://github.com/sindrets/diffview.nvim
-- Rich multi-file diff and commit history UI.
-- Complements gitsigns (per-hunk ops) and lazygit (full TUI).
--
-- Keymaps:
--   <leader>gd  open diff against HEAD (all changed files)
--   <leader>gD  close diffview
--   <leader>gf  history for the current file
--   <leader>gF  history for the entire repo
--
-- Inside diffview, q closes it; Tab/S-Tab cycle between files in the panel.
return {
  "sindrets/diffview.nvim",
  cmd  = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Diffview: diff HEAD" },
    { "<leader>gD", "<cmd>DiffviewClose<cr>",         desc = "Diffview: close" },
    { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: file history" },
    { "<leader>gF", "<cmd>DiffviewFileHistory<cr>",   desc = "Diffview: repo history" },
  },
  opts = {
    enhanced_diff_hl = true,
    view = {
      default    = { layout = "diff2_horizontal" },
      merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true },
    },
    file_panel = {
      win_config = { position = "left", width = 35 },
    },
    hooks = {
      -- Close diffview with q from either the file panel or a diff buffer
      view_opened = function()
        vim.keymap.set("n", "q", "<cmd>DiffviewClose<cr>",
          { buffer = true, silent = true, desc = "Close diffview" })
      end,
    },
  },
}
