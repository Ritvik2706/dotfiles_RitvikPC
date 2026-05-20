-- Markdown heading highlights — applied after colorscheme loads (see init.lua)
local colors = require("config.colors")

local accents = {
  colors["linkarzu_color04"], -- H1
  colors["linkarzu_color02"], -- H2
  colors["linkarzu_color03"], -- H3
  colors["linkarzu_color01"], -- H4
  colors["linkarzu_color05"], -- H5
  colors["linkarzu_color08"], -- H6
}

local is_transparent = vim.g.md_heading_bg == "transparent"

for i, accent in ipairs(accents) do
  vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", {
    bold = true,
    bg   = is_transparent and colors["linkarzu_color13"] or accent,
    fg   = is_transparent and accent                    or colors["linkarzu_color26"],
  })
end
