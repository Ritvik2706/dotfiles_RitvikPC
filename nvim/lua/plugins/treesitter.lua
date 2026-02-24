-- https://github.com/nvim-treesitter/nvim-treesitter

-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/treesitter.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/treesitter.lua

-- SQL wasn't showing in my codeblocks when working with .md files, that's
-- how I found out it was missing from treesitter

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- User's primary languages
        "c", "cpp",
        "java",
        "python",
        "php",
        "javascript", "typescript", "tsx",
        "ocaml", "ocaml_interface",
        -- Common CS / uni languages
        "go", "rust", "lua",
        "bash", "sql", "dockerfile",
        "html", "css",
        "json", "jsonc", "yaml", "toml",
        "markdown", "markdown_inline",
        "vim", "vimdoc", "regex",
      },
      auto_install = false,
      -- Sync install (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      ignore_install = {},

      highlight = {
        enable = true,
        -- Disable for files over 100 KB
        disable = function(lang, buf)
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        additional_vim_regex_highlighting = false,
      },

      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },

      -- TS-based indent is expensive and often wrong — use LSP indent instead
      indent = {
        enable = false,
      },
    },
  },
}
