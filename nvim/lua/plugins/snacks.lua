-- snacks.nvim — debloated
-- Keeps: grep picker, file picker, lazygit, git log

return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Snacks enables a scroll animator by default — disable it so gg/G jump instantly
      scroll    = { enabled = false },
      -- Explorer loads on BufEnter even with the keymap disabled — explicitly turn it off
      explorer  = { enabled = false },
      picker = {
        -- Default to ivy (bottom-docked) for all pickers
        layout = {
          preset = "ivy",
          cycle = false,
        },
        layouts = {
          ivy = {
            layout = {
              box       = "vertical",
              backdrop  = false,
              row       = -1,    -- anchor to bottom of screen
              width     = 0,     -- full width
              height    = 0.5,
              border    = "top",
              title     = " {title} {live} {flags}",
              title_pos = "left",
              { win = "input", height = 1, border = "bottom" },
              {
                box = "horizontal",
                { win = "list",    border = "none" },
                { win = "preview", title = "{preview}", width = 0.5, border = "left" },
              },
            },
          },
          vertical = {
            layout = {
              backdrop  = false,
              width     = 0.8,
              min_width = 80,
              height    = 0.8,
              min_height = 30,
              box       = "vertical",
              border    = "rounded",
              title     = "{title} {live} {flags}",
              title_pos = "center",
              { win = "input",   height = 1, border = "bottom" },
              { win = "list",    border = "none" },
              { win = "preview", title = "{preview}", height = 0.4, border = "top" },
            },
          },
        },
        win = {
          input = {
            keys = {
              ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<M-j>"] = { "list_down", mode = { "i", "n" } },
              ["<M-k>"] = { "list_up",   mode = { "i", "n" } },
            },
          },
        },
        formatters = {
          file = {
            filename_first = true,
            truncate = 80,
          },
        },
      },
    },
    keys = {
      -- Disable snacks' default file explorer (we use mini.files)
      { "<leader>e", false },

      -- Grep across project
      {
        "<leader>sg",
        function()
          Snacks.picker.grep({
            exclude = { "dictionaries/words.txt" },
            on_show = function() vim.cmd.startinsert() end,
          })
        end,
        desc = "Grep (project)",
      },

      -- Find files
      {
        "<leader>sf",
        function()
          Snacks.picker.files({ on_show = function() vim.cmd.startinsert() end })
        end,
        desc = "Find Files",
      },

      -- Fuzzy buffer switcher (Snacks picker)
      {
        "<leader>h",
        function()
          Snacks.picker.buffers({
            on_show     = function() vim.cmd.startinsert() end,
            finder      = "buffers",
            format      = "buffer",
            hidden      = false,
            unloaded    = true,
            current     = true,
            sort_lastused = true,
            win = {
              input = { keys = { ["d"] = "bufdelete" } },
              list  = { keys = { ["d"] = "bufdelete" } },
            },
          })
        end,
        desc = "[P]Snacks picker buffers",
      },

      -- Git log (vertical layout)
      {
        "<leader>gl",
        function()
          Snacks.picker.git_log({
            finder  = "git_log",
            format  = "git_log",
            preview = "git_show",
            confirm = "git_checkout",
            layout  = "vertical",
            on_show = function() vim.cmd.startinsert() end,
          })
        end,
        desc = "Git Log",
      },
    },
  },
}
