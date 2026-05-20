-- https://github.com/folke/noice.nvim
return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        bottom_search  = false,   -- false = floating popup for / search
        lsp_doc_border = true,    -- border on K hover / signature help
      },
      messages = {
        enabled      = true,
        view         = "mini",
        view_error   = "mini",
        view_warn    = "mini",
        view_history = "mini",
        view_search  = "mini",
      },
      notify = {
        enabled = false, -- avoid conflicts; routes below handle filtering
        view    = "mini",
      },
      lsp = {
        message  = { enabled = false, view = "mini" },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"]                = true,
        },
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
              { find = "%d fewer lines" },
              { find = "%d more lines" },
            },
          },
          opts = { skip = true },
        },
        -- Hide treesitter error messages that are non-critical
        {
          filter = {
            event = "notify",
            kind = "error",
            find = "Query error.*substitute",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            kind = "error",
            find = "Invalid node type",
          },
          opts = { skip = true },
        },
        -- Suppress LazyVim's mason rename warnings (we don't use mason)
        {
          filter = {
            event = "notify",
            find = "mason%-lspconfig",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            find = "mason%.nvim",
          },
          opts = { skip = true },
        },
        -- Suppress nvim-treesitter tree-sitter CLI requirement warning
        {
          filter = {
            event = "notify",
            find = "tree%-sitter",
          },
          opts = { skip = true },
        },
        {
          filter = {
            event = "notify",
            find = "nvim%-treesitter",
          },
          opts = { skip = true },
        },
        -- Suppress jdtls (Java LSP) progress spam
        {
          filter = {
            event = "notify",
            any = {
              { find = "Publish Diagnostics" },
              { find = "Validate documents" },
              { find = "jdtls" },
            },
          },
          opts = { skip = true },
        },
        -- Suppress all LSP progress notifications
        {
          filter = { event = "lsp", kind = "progress" },
          opts = { skip = true },
        },
      },
      views = {
        -- This sets the position for the search popup that shows up with / or with :
        cmdline_popup = {
          position = {
            row = "40%",
            col = "50%",
          },
        },
        mini = {
          timeout = 5000,
          align = "center",
          position = {
            -- Centers messages top to bottom
            row = "95%",
            -- Aligns messages to the far right
            col = "100%",
          },
        },
      },
    },
  },
}
