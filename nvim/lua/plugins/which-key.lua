return {
  "folke/which-key.nvim",
  opts = {
    delay = 1000,
    win = {
      width = { min = 30, max = 90 },
    },
    spec = {
      { "<leader>t", group = "toggle", mode = { "n" } },
    },
  },
}
