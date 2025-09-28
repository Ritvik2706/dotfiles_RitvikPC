-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/conform.lua
-- https://github.com/stevearc/conform.nvim

-- IMPORTANT:
-- We avoid formatting on FocusLost/BufLeave because some LSPs/formatters (notably for Java)
-- can race when buffers are in-flight, leading to line loss or broken code.
-- We switch to guarded format-on-save only.

return {
  "stevearc/conform.nvim",
  optional = true,
  opts = function()
    local util = require("conform.util")

    -- Helper: decide if we should auto-format this buffer on save
    local function should_format(bufnr)
      -- Skip special/ephemeral buffers
      if vim.bo[bufnr].buftype ~= "" then
        return false
      end
      if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
        return false
      end

      -- Skip very large files (> 1MB)
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name == "" then
        return false
      end
      local ok, stat = pcall(vim.uv.fs_stat, name)
      if ok and stat and stat.size and stat.size > 1024 * 1024 then
        return false
      end

      -- Allow users to disable per-buffer with: :let b:disable_autoformat = 1
      if vim.b[bufnr].disable_autoformat then
        return false
      end

      -- Respect LazyVim’s global/buffer toggles if present
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
      -- Never surprise-format via LSP if no external formatter is set
      -- (prevents accidental destructive changes)
      default_format_opts = {
        lsp_fallback = false,
        timeout_ms = 2000,
        async = false,
      },

      -- Guarded format-on-save
      format_on_save = function(bufnr)
        if not should_format(bufnr) then
          return nil
        end

        local ft = vim.bo[bufnr].filetype

        -- Extra caution for Java: only format if google-java-format is available
        if ft == "java" then
          -- If the formatter binary is missing, do not fallback to LSP
          local gjf = require("conform").get_formatter_info("google-java-format", bufnr)
          if not (gjf and gjf.available) then
            return nil
          end
          return { lsp_fallback = false, timeout_ms = 3000 }
        end

        -- General case
        return { lsp_fallback = false, timeout_ms = 2000 }
      end,

      notify_on_error = false,

      formatters_by_ft = {
        -- Keep markdown unformatted (you explicitly disabled due to underscore escaping)
        markdown = {},

        -- Your note about templ: ensure the CLI is used
        templ = { "templ" },

        -- Python: use ruff_format for speed/reliability (you mentioned ruff timeout issues)
        python = { "ruff_format" },

        -- Java: use google-java-format (safe & deterministic)
        -- Make sure the binary exists (e.g., installed via Mason or system package)
        java = { "google-java-format" },

        -- Common good defaults (adjust as you like)
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        fish = { "fish_indent" },

        -- Web stack
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

        -- C-family: many teams rely on clang-format; keep it explicit & opt-in
        -- (you previously skipped C/C++; leaving them enabled here but feel free to empty them)
        c = { "clang_format" },
        cpp = { "clang_format" },

        -- Misc
        toml = { "taplo" },
        nix = { "nixfmt" },
        go = { "gofmt" }, -- or "goimports"
        rust = { "rustfmt" },
      },

      -- Per-formatter fine-tuning
      formatters = {
        ["google-java-format"] = {
          -- Choose your style: comment "--aosp" to use Google default
          -- extra_args = { "--aosp" },
          -- Run in project root if possible
          cwd = util.root_file({
            "gradlew",
            "mvnw",
            "pom.xml",
            "build.gradle",
            "settings.gradle",
            "settings.gradle.kts",
          }) or util.root_pattern(".git"),
        },

        shfmt = {
          extra_args = { "-i", "2", "-ci" }, -- 2-space, indent switch cases
        },

        prettier = {
          -- Let Prettier pick local config if present; otherwise use sane defaults
          try_node_modules = true,
        },

        clang_format = {
          -- Respect project .clang-format if present; otherwise keep defaults
          cwd = util.root_pattern(".clang-format", ".clang-format.yml", ".git"),
        },

        rustfmt = {
          -- Use rust-toolchain project if available
          cwd = util.root_pattern("Cargo.toml", "rust-toolchain.toml", ".git"),
        },

        gofmt = {
          cwd = util.root_pattern("go.mod", ".git"),
        },

        ruff_format = {
          -- Respect pyproject.toml if present
          cwd = util.root_pattern("pyproject.toml", ".ruff.toml", ".git"),
        },

        templ = {
          -- Ensure it runs at project root if possible
          cwd = util.root_pattern("go.mod", ".git"),
        },
      },
    }
  end,
}
