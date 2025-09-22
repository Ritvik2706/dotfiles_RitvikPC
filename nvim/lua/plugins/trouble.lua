-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/trouble.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/trouble.lua

return {
  "folke/trouble.nvim",
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
    keys = {
      -- If I close the incorrect pane, I can bring it up with ctrl+o
      ["<esc>"] = "close",
    },
    -- Disable highlighting in trouble panel
    focus = false,
    follow = false,
    auto_refresh = true,
    -- Remove syntax highlighting from trouble items
    formatters = {
      source = {
        format = function(ctx)
          return string.format(" %s", ctx.item.source or "")
        end,
        highlight = false,
      },
      message = {
        format = function(ctx)
          return ctx.item.message
        end,
        highlight = false,
      },
    },
  },
}
