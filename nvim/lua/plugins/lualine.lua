-- Status line
local colors = require("config.colors")
local icons  = LazyVim.config.icons

-- ─── Cache ────────────────────────────────────────────────────────────────────
-- Populated by autocmds below; read by lualine component functions.
-- This keeps component functions pure table lookups — no shell calls on refresh.

local cache = {
  branch           = "",
  branch_color     = nil,
  file_permissions = { perms = "", color = colors["linkarzu_color03"] },
}

-- Async git branch — fires on BufEnter/FocusGained, never blocks the UI
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained" }, {
  callback = function()
    vim.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }, { text = true }, function(out)
      vim.schedule(function()
        cache.branch      = out.code == 0 and out.stdout:gsub("\n", "") or ""
        cache.branch_color = (cache.branch == "live")
          and { fg = colors["linkarzu_color11"], gui = "bold" }
          or nil
      end)
    end)
  end,
})

-- File permissions (sh files only) — cached so lualine reads a plain table
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
  callback = function()
    if vim.bo.filetype ~= "sh" then
      cache.file_permissions = { perms = "", color = colors["linkarzu_color03"] }
      return
    end
    local path = vim.fn.expand("%:p")
    if path == "" then return end
    local perms = vim.fn.getfperm(path)
    cache.file_permissions = {
      perms  = perms,
      color  = perms:sub(1, 3) == "rwx"
        and colors["linkarzu_color02"]
        or  colors["linkarzu_color03"],
    }
  end,
})

-- ─── Helpers ──────────────────────────────────────────────────────────────────

local lang_map = { en = "EN", es = "ES" }

local function get_venv_name()
  local venv = os.getenv("VIRTUAL_ENV")
  return venv and venv:match("([^/]+)$") or ""
end

local function showing_permissions()
  return vim.bo.filetype == "sh" and vim.fn.expand("%:p") ~= ""
end

local function showing_spell()
  return vim.bo.filetype == "markdown" and vim.wo.spell
end

-- Powerline left-arrow separator; optional condition hides it with its neighbour
local function separator(cond)
  return {
    function() return "" end,
    cond      = cond,
    color     = { fg = colors["linkarzu_color14"], bg = colors["linkarzu_color17"] },
    separator = { left = "", right = "" },
    padding   = 0,
  }
end

-- ─── Plugin spec ──────────────────────────────────────────────────────────────

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    -- Skitty is a minimal note-taking mode activated externally via vim.g.neovim_mode
    if vim.g.neovim_mode == "skitty" then
      opts.sections = {
        lualine_a = { function() return "skitty-notes" end },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {
          {
            "diff",
            symbols = {
              added    = icons.git.added,
              modified = icons.git.modified,
              removed  = icons.git.removed,
            },
          },
        },
        lualine_y = {},
        lualine_z = {},
      }
      return opts
    end

    -- ── Section B: branch + venv ─────────────────────────────────────────────
    opts.sections.lualine_b = {
      {
        function() return cache.branch end,
        color     = function() return cache.branch_color end,
        separator = { right = "" },
      },
      {
        get_venv_name,
        color     = { fg = colors["linkarzu_color10"], bg = colors["linkarzu_color02"], gui = "bold" },
        separator = { right = "" },
      },
    }

    -- ── Section C: diagnostics ───────────────────────────────────────────────
    opts.sections.lualine_c = {
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn  = icons.diagnostics.Warn,
          info  = icons.diagnostics.Info,
          hint  = icons.diagnostics.Hint,
        },
      },
    }

    -- ── Section Y: position ──────────────────────────────────────────────────
    opts.sections.lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding   = { left = 0, right = 1 } },
    }

    opts.sections.lualine_z = {}

    -- ── Section X: spell → permissions (both optional) ───────────────────────
    table.insert(opts.sections.lualine_x, 1, separator(showing_spell))
    table.insert(opts.sections.lualine_x, 2, {
      function() return lang_map[vim.bo.spelllang] or vim.bo.spelllang end,
      cond      = showing_spell,
      color     = function()
        return {
          fg  = vim.wo.spell and colors["linkarzu_color02"] or colors["linkarzu_color08"],
          bg  = colors["linkarzu_color17"],
          gui = "bold",
        }
      end,
      separator = { left = "", right = "" },
      padding   = 1,
    })

    table.insert(opts.sections.lualine_x, 3, separator(showing_permissions))
    table.insert(opts.sections.lualine_x, 4, {
      function() return cache.file_permissions.perms end,
      cond      = showing_permissions,
      color     = function()
        return { fg = cache.file_permissions.color, bg = colors["linkarzu_color17"], gui = "bold" }
      end,
      separator = { left = "", right = "" },
      padding   = 1,
    })

    table.insert(opts.sections.lualine_x, 5, separator())

    opts.extensions = { "lazy", "fzf" }
  end,
}
