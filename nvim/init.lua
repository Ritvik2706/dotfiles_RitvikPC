-- Personal Neovim Configuration
-- Cleaned for Linux compatibility

-- Environment variable for neovim mode (can be set in shell if needed)
vim.g.neovim_mode = vim.env.NEOVIM_MODE or "default"

-- Markdown heading background style (solid or transparent)
vim.g.md_heading_bg = vim.env.MD_HEADING_BG or "transparent"

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- Load custom highlights, I tried adding this as an autocommand, in the options.lua
-- file, also in the markdownl.lua file, but the highlights kept being overriden
-- so this is the only way I was able to make it work
-- Require the colors.lua module and access the colors directly without
-- additional file reads
require("config.highlights")

-- Delay for `skitty` configuration
-- If I don't add this delay, I get the message
-- "Press ENTER or type command to continue"
if vim.g.neovim_mode == "skitty" then
  vim.wait(500, function()
    return false
  end) -- Wait for X miliseconds without doing anything
end
