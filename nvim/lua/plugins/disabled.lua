-- Disable LazyVim built-in plugins we don't need in the debloated config

return {
  -- ─── Navigation ───────────────────────────────────────────────────────────────
  { "folke/flash.nvim",            enabled = false },

  -- ─── File-tree (we use mini.files + oil instead) ──────────────────────────────
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- ─── Linting / null-ls (not needed, can re-enable per project later) ──────────
  { "mfussenegger/nvim-lint",      enabled = false },
  { "nvimtools/none-ls.nvim",      enabled = false },

  -- ─── Tabline (we use winbar instead) ─────────────────────────────────────────
  { "akinsho/bufferline.nvim",     enabled = false },
}
