-- Debloated lazy.nvim setup — LazyVim base only, no language/formatter extras

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim base
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- Language extras
    { import = "lazyvim.plugins.extras.lang.java"       },
    { import = "lazyvim.plugins.extras.lang.clangd"      }, -- C/C++
    { import = "lazyvim.plugins.extras.lang.python"     },
    { import = "lazyvim.plugins.extras.lang.php"        },
    { import = "lazyvim.plugins.extras.lang.typescript" }, -- covers JS too
    { import = "lazyvim.plugins.extras.lang.go"         },
    { import = "lazyvim.plugins.extras.lang.rust"       },
    { import = "lazyvim.plugins.extras.lang.json"       },
    { import = "lazyvim.plugins.extras.lang.yaml"       },
    { import = "lazyvim.plugins.extras.lang.markdown"   },
    -- Formatting
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    -- Your custom plugins
    { import = "plugins" },
    { import = "plugins.colorschemes" },
  },
  defaults = {
    lazy = true,   -- load plugins on demand, not all at startup
    version = false,
  },
  checker = {
    enabled = false, -- disabled: network check in WSL causes multi-second startup freeze
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "zipPlugin",
        "netrwPlugin",  -- we use oil/mini.files/yazi instead
        "tutor",
        "rplugin",
        "osc52",
      },
    },
  },
})
