-- Image clipboard plugin configuration
-- https://github.com/HakonHarnes/img-clip.nvim

return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    default = {
      -- file and directory options
      use_absolute_path = false, -- Use relative paths for portability
      relative_to_current_file = true, -- Save images relative to current file

      -- Conditional dir_path based on neovim mode
      dir_path = vim.g.neovim_mode == "skitty" and "img" or function()
        return vim.fn.expand("%:t:r") .. "-img"
      end,

      -- Auto-generate filename with timestamp
      prompt_for_file_name = false,
      file_name = "%y%m%d-%H%M%S",

      -- Image format and quality settings
      extension = "avif",
      process_cmd = "convert - -quality 75 avif:-",
    },

    -- filetype specific options
    filetypes = {
      markdown = {
        url_encode_path = true,
        -- Conditional template for different modes
        template = vim.g.neovim_mode == "skitty" and "![ ](./$FILE_PATH)" or "![Image](./$FILE_PATH)",
      },
    },
  },
}
