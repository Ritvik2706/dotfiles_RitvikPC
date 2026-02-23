-- blink.cmp — ghost-text mode
-- • Grey inline ghost text shows the top suggestion as you type
-- • <Tab> accepts it (or moves to next snippet field)
-- • No popup menu unless you ask with <C-space>
-- • No AI sources

return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    -- Disable in file-picker / prompt buffers
    opts.enabled = function()
      local ft = vim.bo[0].filetype
      return ft ~= "minifiles" and ft ~= "snacks_picker_input"
    end

    -- Sources: LSP, path, buffer — no AI/emoji/dictionary
    opts.sources = vim.tbl_deep_extend("force", opts.sources or {}, {
      default = { "lsp", "path", "buffer" },
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 90,
          min_keyword_length = 0,
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 25,
          fallbacks = { "buffer" },
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
            show_hidden_files_by_default = true,
          },
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = 15,
          min_keyword_length = 2,
          max_items = 5,
        },
      },
    })

    opts.cmdline = { enabled = true }

    opts.completion = {
      -- Ghost text: shows top suggestion inline in grey, no popup
      ghost_text = {
        enabled = true,
      },
      menu = {
        -- Don't pop up automatically — only show when user asks
        auto_show = false,
        border = "single",
        max_height = 15,
      },
      documentation = {
        -- Show docs when the popup menu is open
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "single",
        },
      },
    }

    opts.keymap = {
      preset = "none",
      -- Accept ghost text / selected menu item
      ["<M-y>"]     = { "accept", "fallback" },
      -- Snippet field navigation
      ["<Tab>"]     = { "snippet_forward", "fallback" },
      ["<S-Tab>"]   = { "snippet_backward", "fallback" },
      -- Show/hide the popup menu on demand
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"]     = { "hide", "fallback" },
      -- Navigate the popup menu when it IS open
      ["<M-j>"]     = { "select_next", "fallback" },
      ["<M-k>"]     = { "select_prev", "fallback" },
      ["<Down>"]    = { "select_next", "fallback" },
      ["<Up>"]      = { "select_prev", "fallback" },
      -- Scroll docs
      ["<S-k>"]     = { "scroll_documentation_up", "fallback" },
      ["<S-j>"]     = { "scroll_documentation_down", "fallback" },
    }

    return opts
  end,
}
