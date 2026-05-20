-- https://github.com/hedyhli/outline.nvim
-- Symbol tree sidebar: all functions, classes, and methods in the current file.
-- Useful when navigating large files across your 8 languages.
--
-- Keymap: <leader>cs  toggle (keeps LazyVim convention for "code symbols")
-- Inside the outline: <CR> jumps, h/l fold/unfold, q/<Esc> close
return {
  "hedyhli/outline.nvim",
  cmd  = { "Outline", "OutlineOpen" },
  keys = {
    { "<leader>cs", "<cmd>Outline<cr>", desc = "Toggle symbol outline" },
  },
  opts = {
    outline_window = {
      position   = "right",
      width      = 30,
      auto_close = true,   -- close when jumping to a symbol
      auto_jump  = false,
    },
    outline_items = {
      show_symbol_lineno = true,
    },
    preview_window = {
      auto_preview = false,  -- use K (hover) instead of a floating preview
    },
    keymaps = {
      close         = { "<Esc>", "q" },
      goto_location = "<CR>",
      fold          = "h",
      unfold        = "l",
      fold_all      = "zM",
      unfold_all    = "zR",
    },
  },
}
