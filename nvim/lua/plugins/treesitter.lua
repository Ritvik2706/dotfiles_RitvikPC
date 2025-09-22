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
        -- Core CS languages
        "c",
        "cpp", 
        "python",
        "java",
        "rust",
        "go",
        "javascript",
        "typescript",
        "lua",
        
        -- Web and markup
        "html",
        "css",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown_inline",
        
        -- Scripting and config
        "bash",
        "sql", 
        "dockerfile",
        "vim",
        "vimdoc",
        
        -- Additional useful ones
        "regex",
        "csv",
        "templ",
        "php",
        "promql",
        "glsl",
      },
      -- Auto install parsers when entering new file types
      auto_install = true,
      -- Sync install (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      ignore_install = {},
      
      highlight = {
        enable = true,
        -- Set this to false if you have an `updatetime` of ~25 or so
        disable = function(lang, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
        -- Add some debounce to prevent conflicts with auto-save
        use_languagetree = true,
        is_supported = function(lang)
          -- Skip highlighting during auto-save operations to prevent conflicts
          if vim.g.auto_save_in_progress then
            return false
          end
          return true
        end,
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
      
      -- Enable treesitter-based indentation (temporarily disabled for debugging)
      indent = {
        enable = false,  -- Temporarily disabled to test
        -- Disable for specific languages if they have issues
        disable = {},
      },
    },
  },
}
