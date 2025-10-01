-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/conform.lua
-- https://github.com/stevearc/conform.nvim

return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function()
    local util = require("conform.util")

    local function should_format(bufnr)
      if vim.bo[bufnr].buftype ~= "" then
        return false
      end
      if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
        return false
      end
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then
        return false
      end
      local ok, stat = pcall(vim.uv.fs_stat, name)
      if ok and stat and stat.size and stat.size > 1024 * 1024 then
        return false
      end
      if vim.b[bufnr].disable_autoformat then
        return false
      end
      if package.loaded["lazyvim.util"] or package.loaded["lazyvim.plugins.lsp.format"] then
        local ok_lv, LazyVim = pcall(function()
          return require("lazyvim.util")
        end)
        if ok_lv and LazyVim.format and not LazyVim.format.enabled(bufnr) then
          return false
        end
      end
      return true
    end

    return {
      default_format_opts = { lsp_fallback = false, timeout_ms = 2000, async = false },

      format_on_save = function(bufnr)
        if not should_format(bufnr) then
          return nil
        end
        local ft = vim.bo[bufnr].filetype
        if ft == "java" then
          local gjf = require("conform").get_formatter_info("google-java-format", bufnr)
          if not (gjf and gjf.available) then
            return nil
          end
          return { lsp_fallback = false, timeout_ms = 3000 }
        end
        return { lsp_fallback = false, timeout_ms = 2000 }
      end,

      notify_on_error = false,

      formatters_by_ft = {
        markdown = {},
        templ = { "templ" },
        python = { "ruff_format" },
        java = { "google-java-format" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        fish = { "fish_indent" },

        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },

        c = { "clang_format" },
        cpp = { "clang_format" },

        toml = { "taplo" },
        nix = { "nixfmt" },
        go = { "gofmt" },
        rust = { "rustfmt" },
      },

      formatters = {
        ["google-java-format"] = {
          -- extra_args = { "--aosp" },
          -- Look for common Java project roots or .git
          cwd = util.root_file({
            "gradlew",
            "mvnw",
            "pom.xml",
            "build.gradle",
            "settings.gradle",
            "settings.gradle.kts",
            ".git",
          }),
        },

        shfmt = { extra_args = { "-i", "2", "-ci" } },

        prettier = { try_node_modules = true },

        clang_format = {
          -- Use nearest .clang-format or fall back to repo root
          cwd = util.root_file({ ".clang-format", ".clang-format.yml", ".git" }),
        },

        rustfmt = {
          cwd = util.root_file({ "Cargo.toml", "rust-toolchain.toml", ".git" }),
        },

        gofmt = {
          cwd = util.root_file({ "go.mod", ".git" }),
        },

        ruff_format = {
          cwd = util.root_file({ "pyproject.toml", ".ruff.toml", ".git" }),
        },

        templ = {
          cwd = util.root_file({ "go.mod", ".git" }),
        },
      },
    }
  end,
}
