-- https://github.com/leath-dub/snipe.nvim
-- Letter-hint buffer switcher (similar to harpoon-style quick jumps)
return {
  "leath-dub/snipe.nvim",
  keys = {
    {
      "<leader>l",
      function()
        require("snipe").open_buffer_menu()
      end,
      desc = "Open Snipe buffer menu",
    },
  },
  config = function()
    local snipe = require("snipe")
    snipe.setup({
      hints = {
        -- Characters used for hint labels — avoid collisions with navigate keys
        dictionary = "asfghl;wertyuiop",
      },
      navigate = {
        cancel_snipe = "<esc>",
        -- Press d over a buffer entry to close that buffer
        close_buffer = "d",
      },
      -- "default" keeps letters stable; "last" always assigns 'a' to the most recent buffer
      sort = "default",
    })
  end,
}
