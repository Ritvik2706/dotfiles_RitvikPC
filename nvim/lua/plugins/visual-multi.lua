-- https://github.com/mg979/vim-visual-multi
-- Multiple cursors. Already installed by LazyVim; this file configures it.
--
-- BEHAVIOUR CHANGE: <C-n> in normal/visual mode selects the word under the
-- cursor and enters multi-cursor mode. From there:
--   <C-n>   add next occurrence of the same word
--   q       skip this occurrence and go to next
--   Q       remove current cursor
--   <Esc>   exit multi-cursor mode
--   All normal operators (d, c, y, >, <) and insert-mode edits apply to
--   every cursor simultaneously.
return {
  "mg979/vim-visual-multi",
  event = "LazyFile",
  init = function()
    vim.g.VM_show_warnings  = 0  -- suppress "N cursors" status spam
    vim.g.VM_silent_exit    = 1  -- no "Exited VM" flash message
    vim.g.VM_set_statusline = 0  -- don't override lualine
  end,
}
