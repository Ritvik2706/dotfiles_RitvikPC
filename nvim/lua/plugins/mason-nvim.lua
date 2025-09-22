-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/mason-nvim.lua

-- https://github.com/williamboman/mason.nvim
-- https://github.com/jonschlinkert/markdown-toc
return {
  "mason-org/mason.nvim",
  opts = {
    ensure_installed = {
      -- I installed "templ" and other LSPS, these requirements can be found in
      -- the TEMPL docs https://templ.guide/commands-and-tools/ide-support/#neovim--050
      -- The templ command must be in your system path for the LSP to be able to start
      -- vim.list_extend(opts.ensure_installed, { "templ", "html-lsp", "htmx-lsp", "tailwindcss-language-server" })
      "templ",
      "html-lsp",
      "htmx-lsp",
      "tailwindcss-language-server",
      "harper-ls",
      "clangd",  -- C/C++ LSP for syntax checking and diagnostics
      
      -- Core CS languages
      "pyright",           -- Python LSP
      "jdtls",            -- Java LSP (correct name)
      "rust-analyzer",     -- Rust LSP
      "gopls",            -- Go LSP
      
      -- Web development (common in CS curricula)
      "typescript-language-server", -- JavaScript/TypeScript
      "json-lsp",         -- JSON (correct name)
      "yaml-language-server",        -- YAML
      
      -- Scripting and shell
      "bash-language-server",  -- Bash/Shell scripts
      "lua-language-server",   -- Lua
      
      -- Database and markup
      "sqlls",            -- SQL
      "marksman",         -- Markdown
      
      -- Optional but useful for CS
      "dockerfile-language-server", -- Docker
      "terraform-ls",     -- Infrastructure as Code
      -- marksman and markdownlint come by default in the lazyvim config
      --
      -- I installed markdown-toc as I use to to automatically create and upate
      -- the TOC at the top of each file
      -- vim.list_extend(opts.ensure_installed, { "markdownlint-cli2", "marksman", "markdown-toc" })
    },
  },
}
