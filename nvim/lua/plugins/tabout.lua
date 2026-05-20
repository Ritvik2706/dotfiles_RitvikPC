-- https://github.com/abecodes/tabout.nvim
-- Jump past the next closing bracket/quote with <Tab> in insert mode.
--
-- BEHAVIOUR CHANGE: pressing <Tab> inside ( " ' ` [ { now exits it instead
-- of inserting a literal tab. blink.cmp's snippet_forward still takes priority
-- (Tab advances snippet fields first); this activates only on fallback.
-- S-Tab jumps backwards through brackets the same way.
--
-- Load order matters: this must be listed as a blink.cmp dependency (see
-- blink-cmp.lua) so it registers its <Tab> handler first, then blink loads on
-- top. blink's "fallback" action then correctly calls tabout underneath.
return {
  "abecodes/tabout.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    tabkey           = "<Tab>",
    backwards_tabkey = "<S-Tab>",
    completion       = false,  -- let blink manage completion; we just handle brackets
    act_as_tab       = true,   -- insert a real tab when nothing to jump out of
    ignore_beginning = true,
    tabouts = {
      { open = "'",  close = "'" },
      { open = '"',  close = '"' },
      { open = "`",  close = "`" },
      { open = "(",  close = ")" },
      { open = "[",  close = "]" },
      { open = "{",  close = "}" },
    },
  },
}
