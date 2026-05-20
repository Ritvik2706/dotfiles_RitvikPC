-- Inline hex colour preview — #rrggbb values are highlighted with their actual colour.
-- Also handles 3-digit shorthand: #abc → treated as #aabbcc.
-- Purely visual, zero keymap changes.
return {
  "nvim-mini/mini.hipatterns",
  event = "LazyFile",
  opts = function()
    local hi = require("mini.hipatterns")
    return {
      highlighters = {
        hex_color = hi.gen_highlighter.hex_color({ priority = 2000 }),
        shorthand = {
          pattern = "()#%x%x%x()%f[^%x%w]",
          group = function(_, _, data)
            local m = data.full_match
            local r, g, b = m:sub(2, 2), m:sub(3, 3), m:sub(4, 4)
            return MiniHipatterns.compute_hex_color_group(
              "#" .. r .. r .. g .. g .. b .. b, "bg"
            )
          end,
          extmark_opts = { priority = 2000 },
        },
      },
    }
  end,
  config = function(_, opts)
    require("mini.hipatterns").setup(opts)
  end,
}
