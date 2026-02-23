-- LSP configuration
-- LazyVim extras handle: Java (jdtls), C/C++ (clangd), Python (pyright),
-- PHP (intelephense), JS/TS (ts_ls), Go (gopls), Rust (rust-analyzer)
-- This file adds OCaml and any global LSP tweaks.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Global diagnostic display
      diagnostics = {
        underline = true,
        update_in_insert = false, -- don't show errors while typing
        virtual_text = {
          spacing = 4,
          source = "if_many",    -- show source name only when multiple LSPs active
          prefix = "●",
        },
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,          -- show which LSP reported the error
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
        },
      },
      -- Show diagnostic float automatically when cursor rests on an error
      inlay_hints = { enabled = false },
      -- Extra servers on top of what LazyVim extras provide
      servers = {
        ocamllsp = {},
      },
    },
    init = function()
      -- Override LazyVim's LSP keymaps with our own on every LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true, desc = desc })
          end
          -- Navigation
          map("n", "gd",         vim.lsp.buf.definition,       "Go to definition")
          map("n", "gD",         vim.lsp.buf.declaration,      "Go to declaration")
          map("n", "gr",         vim.lsp.buf.references,       "References")
          map("n", "gi",         vim.lsp.buf.implementation,   "Go to implementation")
          map("n", "gt",         vim.lsp.buf.type_definition,  "Go to type definition")
          -- Docs / signature
          map("n", "K",          vim.lsp.buf.hover,            "Hover docs")
          map("n", "<C-k>",      vim.lsp.buf.signature_help,   "Signature help")
          map("i", "<C-k>",      vim.lsp.buf.signature_help,   "Signature help")
          -- Actions
          map("n", "<leader>ca", vim.lsp.buf.code_action,      "Code action")
          map("v", "<leader>ca", vim.lsp.buf.code_action,      "Code action (selection)")
          map("n", "<leader>cr", vim.lsp.buf.rename,           "Rename symbol")
          map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format file")
          -- Diagnostics
          map("n", "<leader>cd", vim.diagnostic.open_float,    "Show diagnostic float")
          map("n", "]d",         function() vim.diagnostic.jump({ count = 1,  float = true }) end, "Next diagnostic")
          map("n", "[d",         function() vim.diagnostic.jump({ count = -1, float = true }) end, "Prev diagnostic")
          map("n", "]e",         function() vim.diagnostic.jump({ count = 1,  severity = vim.diagnostic.severity.ERROR, float = true }) end, "Next error")
          map("n", "[e",         function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true }) end, "Prev error")
        end,
      })

      -- Show diagnostic float automatically when cursor rests on a line with an error
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
        end,
      })
    end,
  },

  -- Mason: auto-install all servers on first launch
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Covered by LazyVim extras but listed here for reference
        -- Java: jdtls (managed by nvim-jdtls, not listed here)
        "clangd",           -- C / C++
        "pyright",          -- Python
        "intelephense",     -- PHP
        "typescript-language-server", -- JS / TS
        "gopls",            -- Go
        "rust-analyzer",    -- Rust
        -- OCaml (no LazyVim extra)
        "ocaml-lsp",
        -- Formatters
        "prettier",         -- JS / TS / PHP / HTML / CSS / JSON / YAML / Markdown
        "black",            -- Python
        "clang-format",     -- C / C++
      },
    },
  },
}
