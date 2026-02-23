-- snacks.nvim — debloated
-- Keeps: grep picker, file picker, lazygit, git log

return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        win = {
          input = {
            keys = {
              ["<M-j>"] = { "list_down", mode = { "i", "n" } },
              ["<M-k>"] = { "list_up",   mode = { "i", "n" } },
            },
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
          })
        end,
        desc = "Grep (project)",
      },

      -- Find files
      {
        "<leader>sf",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
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
          })
        end,
        desc = "Git Log",
      },
    },
  },
}
