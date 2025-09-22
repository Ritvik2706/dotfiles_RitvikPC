-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set:
-- https://github.com/LazyVim/end

-- Conceallevel setting for better markdown rendering
vim.opt.conceallevel = 0

-- Show LSP diagnostics in a hover window after a short delay
vim.o.updatetime = 200

-- Auto update plugins at startup
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("autoupdate"),
  callback = function()
    if require("lazy.status").has_updates then
      require("lazy").update({ show = false })
    end
  end,
})

-- Session options (save language spell settings)
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
  "localoptions",
}

-- Spell checking language (English by default)
vim.opt.spelllang = { "en" }

-- Neovide configuration (cross-platform GUI client)
if vim.g.neovide then
  -- Use Ctrl instead of Cmd for Linux compatibility
  vim.keymap.set("n", "<C-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<C-c>", '"+y') -- Copy
  vim.keymap.set("n", "<C-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<C-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<C-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<C-v>", '<ESC>l"+Pli') -- Paste insert mode

  -- Font configuration
  vim.o.guifont = "JetBrainsMono Nerd Font:h15"
  
  -- Animation settings
  vim.g.neovide_refresh_rate = 60 -- Conservative setting for Linux
  vim.g.neovide_cursor_animation_length = 0.18
  vim.g.neovide_cursor_short_animation_length = 0.15
  vim.g.neovide_position_animation_length = 0.20
  vim.g.neovide_cursor_trail_size = 7
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
end

-- Cursor appearance
vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor",
  "i-ci-ve:ver25-lCursor",
  "r-cr:hor20-CursorIM",
}

-- Specify leader the default in lazyvim is " "
vim.g.mapleader = " "

-- timeout = true means Neovim will wait for potential mapping completions
-- timeoutlen = 300 gives you 300ms to complete a key mapping sequence (reduced from 1000)
-- This helps prevent characters being inserted when quickly pressing Esc then movement keys
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- ttimeoutlen controls the timeout for terminal key codes (like escape sequences)
-- Setting this to a very low value ensures escape sequences are processed quickly
-- This helps prevent the issue where pressing Esc + j/k inserts characters
-- Using 0 for immediate processing
vim.opt.ttimeout = true
vim.opt.ttimeoutlen = 0

-- Force specific terminal behavior for better escape handling
-- This tells Neovim to be more aggressive about handling escape sequences
vim.opt.ttyfast = true

-- Disable animations for better performance
vim.g.snacks_animate = false

-- Enable clipboard integration - makes yank operations copy to system clipboard
vim.opt.clipboard = "unnamedplus"

-- Conditional settings based on mode
if vim.g.neovim_mode == "skitty" then
  -- Line numbers
  vim.opt.number = true
  vim.opt.relativenumber = true

  -- Disable the gutter
  vim.opt.signcolumn = "no"

  -- Text width and wrapping
  vim.opt.textwidth = 25
  vim.opt.linebreak = false
  vim.opt.wrap = false

  -- No colorcolumn in skitty
  vim.opt.colorcolumn = ""

  local colors = require("config.colors")
  vim.cmd(string.format([[highlight WinBar1 guifg=%s]], colors["linkarzu_color03"]))
  -- Set the winbar to display the current file name on the left (without the extension) and a neutral label aligned to the right
  vim.opt.winbar =
    '%#WinBar1# %{luaeval(\'vim.fn.fnamemodify(vim.fn.expand("%:t"), ":r")\')}%*%=%#WinBar1# Neovim %*'
else
  -- Relative line numbers
  vim.opt.relativenumber = true

  -- Text wrapping at 80 characters
  vim.opt.textwidth = 80
  vim.opt.wrap = true

  -- Show colorcolumn at 80 characters for markdown guidelines
  vim.opt.colorcolumn = "80"

  -- Winbar
  -- Function to shorten long paths (> shorten_if_more_than real dirs)
  local function shorten_path(path)
    local shorten_if_more_than = 6 -- change this to 5, 7, etc
    -- Strip and remember the root ("/" or "~/")
    local prefix = ""
    if path:sub(1, 2) == "~/" then
      prefix = "~/"
      path = path:sub(3)
    elseif path:sub(1, 1) == "/" then
      prefix = "/"
      path = path:sub(2)
    end
    -- Split the remaining path into its components
    local parts = {}
    for part in string.gmatch(path, "[^/]+") do
      table.insert(parts, part)
    end
    -- Shorten only when there are more than shorten_if_more_than directories
    if #parts > shorten_if_more_than then
      local first = parts[1]
      local last_four = table.concat({
        parts[#parts - 3],
        parts[#parts - 2],
        parts[#parts - 1],
        parts[#parts],
      }, "/")
      return prefix .. first .. "/../" .. last_four
    end

    -- Re-attach the prefix when no shortening is needed
    return prefix .. table.concat(parts, "/")
  end
  -- Function to get the full path and replace the home directory with ~
  local function get_winbar_path()
    local full_path = vim.fn.expand("%:p:h")
    return full_path:gsub(vim.fn.expand("$HOME"), "~")
  end
  -- Function to get the number of open buffers using the :ls command
  local function get_buffer_count()
    return vim.fn.len(vim.fn.getbufinfo({ buflisted = 1 }))
  end
  -- Function to update the winbar
  local function update_winbar()
    local home_replaced = get_winbar_path()
    local buffer_count = get_buffer_count()
    local display_path = shorten_path(home_replaced)
    vim.opt.winbar = "%#WinBar1#%m "
      .. "%#WinBar2#("
      .. buffer_count
      .. ") "
      -- this shows the filename on the left
      .. "%#WinBar3#"
      .. vim.fn.expand("%:t")
      -- This shows the file path on the right
      .. "%*%=%#WinBar1#"
      .. display_path
    -- I don't need the hostname as I have it in lualine
    -- .. vim.fn.systemlist("hostname")[1]
  end
  -- Winbar was not being updated after I left lazygit
  vim.api.nvim_create_autocmd({ "BufEnter", "ModeChanged" }, {
    callback = function(args)
      local old_mode = args.event == "ModeChanged" and vim.v.event.old_mode or ""
      local new_mode = args.event == "ModeChanged" and vim.v.event.new_mode or ""
      -- Only update if ModeChanged is relevant (e.g., leaving LazyGit)
      if args.event == "ModeChanged" then
        -- Get buffer filetype
        local buf_ft = vim.bo.filetype
        -- Only update when leaving `snacks_terminal` (LazyGit)
        if buf_ft == "snacks_terminal" or old_mode:match("^t") or new_mode:match("^n") then
          update_winbar()
        end
      else
        update_winbar()
      end
    end,
  })
end

-- -- I tried these 2 with prettier prosewrap in "preserve" mode, and I'm not sure
-- -- what they do, I think lines are wrapped, but existing ones are not, so if I
-- -- have files with really long lines, they will remain the same, also LF
-- -- characters were introduced at the end of each line, not sure, didn't test
-- -- enough
-- --
-- -- Wrap lines at convenient points, this comes enabled by default in lazyvim
-- vim.opt.linebreak = true

-- -- This is my old way of updating the winbar but it stopped working, it
-- -- wasn't showing the entire path, it was being truncated in some dirs
-- vim.opt.winbar = "%#WinBar1#%m %f%*%=%#WinBar2#" .. vim.fn.systemlist("hostname")[1]

-- Enable autochdir to automatically change the working directory to the current file's directory
-- If you go inside a subdir, neotree will open that dir as the root
-- vim.opt.autochdir = true

-- Keeps my cursor in the middle whenever possible
-- This didn't work as expected, but the `stay-centered.lua` plugin did the trick
-- vim.opt.scrolloff = 999

-- If set to 0 it shows all the symbols in a file, like bulletpoints and
-- codeblock languages, obsidian.nvim works better with 1 or 2
-- Set it to 2 if using kitty or codeblocks will look weird
vim.opt.conceallevel = 0

-- -- Function to get the model of my mac, can be used by copilot-chat plugin
-- local function get_computer_model()
--   local ok, handle = pcall(io.popen, "sysctl -n hw.model")
--   if not ok or not handle then
--     return nil
--   end
--   local result = handle:read("*a")
--   handle:close()
--   if result then
--     return result:gsub("^%s*(.-)%s*$", "%1") -- Trim whitespace
--   end
--   return nil
-- end
-- -- Store the computer model globally
-- _G.COMPUTER_MODEL = get_computer_model()
-- -- Compute the Copilot model based on the computer model
-- _G.COPILOT_MODEL = _G.COMPUTER_MODEL == "MacBookPro18,2" and "gpt-4o" or "claude-3.5-sonnet"
-- -- Optional: Create a command to show the computer model
-- vim.api.nvim_create_user_command("ShowComputerModel", function()
--   local model = _G.COMPUTER_MODEL or "Unknown"
--   print("Computer Model: " .. model)
-- end, {})

-- Auto update plugins at startup
-- Tried to add this vimenter autocmd in the autocmds.lua file but it was never
-- triggered, this is because if I understand correctly Lazy.nvim delays the
-- loading of autocmds.lua until after VeryLazy or even after VimEnter
-- The fix is to add the autocmd to a file that’s loaded before VimEnter,
-- such as options.lua
-- https://github.com/LazyVim/LazyVim/issues/2592#issuecomment-2015093693
-- Only upate if there are updates
-- https://github.com/folke/lazy.nvim/issues/702#issuecomment-1903484213
local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("autoupdate"),
  callback = function()
    if require("lazy.status").has_updates then
      require("lazy").update({ show = false })
    end
  end,
})

-- I added `localoptions` to save the language spell settings, otherwise, the
-- language of my markdown documents was not remembered if I set it to spanish
-- or to both en,es
-- See the help for `sessionoptions`
-- `localoptions`: options and mappings local to a window or buffer
-- (not global values for local options)
--
-- The plugin that saves the session information is
-- https://github.com/folke/persistence.nvim and comes enabled in the
-- lazyvim.org distro lamw25wmal
--
-- These sessionoptions come from the lazyvim distro, I just added localoptions
-- https://www.lazyvim.org/configuration/general
vim.opt.sessionoptions = {
  "buffers",
  "curdir",
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
  "localoptions",
}

-- Most of my files have 2 languages, spanish and english, so even if I set the
-- language to spanish, I always add some words in English to my documents, so
-- it's annoying to be adding those to the spanish dictionary
-- vim.opt.spelllang = { "en,es" }

-- I mainly type in english, if I set it to both above, files in English get a
-- bit confused and recognize words in spanish, just for spanish files I need to
-- set it to both
vim.opt.spelllang = { "en" }

-- -- My cursor was working fine, not  sure why it stopped working in wezterm, so
-- -- the config below fixed it
-- --
-- -- NOTE: I think the issues with my cursor started happening when I moved to wezterm
-- -- and started using the "wezterm" terminfo file, when in wezterm, I switched to
-- -- the "xterm-kitty" terminfo file, and the cursor is working great without
-- -- the configuration below. Leaving the config here as reference in case it
-- -- needs to be tested with another terminal emulator in the future
-- --
-- vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"

-- Show LSP diagnostics (inlay hints) in a hover window / popup
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
-- https://www.reddit.com/r/neovim/comments/1168p97/how_can_i_make_lspconfig_wrap_around_these_hints/
-- Time it takes to show the popup after you hover over the line with an error
vim.o.updatetime = 200

-- ############################################################################
--                             Neovide section
-- ############################################################################

-- NOTE: When in LazyGit if inside or outside neovim, if you want to edit files with
-- Neovide, you have to set the os.edit option in the
-- ~/github/dotfiles-latest/lazygit/config.yml file

-- NOTE: Also remember that there are settings in the file:
-- ~/github/dotfiles-latest/neovide/config.toml

-- NOTE: Text looks a bit bolder in Neovide, it doesn't bother me, but I think
-- there's no way to fix it, see:
-- https://github.com/neovide/neovide/issues/1231

-- The copy and paste sections were found on:
-- https://neovide.dev/faq.html#how-can-i-use-cmd-ccmd-v-to-copy-and-paste
if vim.g.neovide then
  vim.keymap.set("n", "<D-s>", ":w<CR>") -- Save
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  -- This allows me to use cmd+v to paste stuff into neovide
  vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })

  -- Specify the font used by Neovide
  -- vim.o.guifont = "MesloLGM_Nerd_Font:h14"
  vim.o.guifont = "JetBrainsMono Nerd Font:h15"
  -- This is limited by the refresh rate of your physical hardware, but can be
  -- lowered to increase battery life
  -- This setting is only effective when not using vsync,
  -- for example by passing --no-vsync on the commandline.
  --
  -- NOTE: vsync is configured in the neovide/config.toml file, I disabled it and set
  -- this to 120 even though my monitor is 75Hz, had a similar case in wezterm,
  -- see: https://github.com/wez/wezterm/issues/6334
  vim.g.neovide_refresh_rate = 120
  -- This is how fast the cursor animation "moves", the higher the number, the
  -- more you will see the trail when jumping to end of line
  -- default 0.150
  vim.g.neovide_cursor_animation_length = 0.18
  -- Time it takes for the cursor to complete its animation in seconds for short
  -- horizontal travels of one or two characters, like when typing.
  -- Default 0.04
  vim.g.neovide_cursor_short_animation_length = 0.15
  -- Time it takes for a window to complete animation from one position to another
  -- position in seconds, such as :split.
  -- Default 0.15
  vim.g.neovide_position_animation_length = 0.20
  -- changes how much the back of the cursor trails the front. Set to 1.0 to
  -- make the front jump to the destination immediately with a maximum trail size.
  -- A lower value makes a smoother animation, with a shorter trail, but also adds lag
  -- Default 0.7
  vim.g.neovide_cursor_trail_size = 7

  -- Really weird issue in which my winbar would be drawn multiple times as I
  -- scrolled down the file, this fixed it, found in:
  -- https://github.com/neovide/neovide/issues/1550
  -- Default 0.3
  vim.g.neovide_scroll_animation_length = 0

  -- produce particles behind the cursor, if want to disable them, set it to ""
  -- vim.g.neovide_cursor_vfx_mode = "railgun"
  -- vim.g.neovide_cursor_vfx_mode = "torpedo"
  -- vim.g.neovide_cursor_vfx_mode = "pixiedust"
  vim.g.neovide_cursor_vfx_mode = "sonicboom"
  -- vim.g.neovide_cursor_vfx_mode = "ripple"
  -- vim.g.neovide_cursor_vfx_mode = "wireframe"

  -- This allows me to use the right "alt" key in macOS, because I have some
  -- neovim keymaps that use alt, like alt+t for the terminal
  -- https://youtu.be/33gQ9p-Zp0I
  vim.g.neovide_input_macos_option_key_is_meta = "only_right"
end

-- I also want the vim.g.neovim_mode cursor color to be changed
-- Neovide cursor color, remember to set these in your colorscheme, I have
-- mine set in ~/github/dotfiles-latest/neovim/neobean/lua/plugins/colorschemes/eldritch.lua
-- Otherwise, my cursor was white
vim.opt.guicursor = {
  "n-v-c-sm:block-Cursor", -- Use 'Cursor' highlight for normal, visual, and command modes
  "i-ci-ve:ver25-lCursor", -- Use 'lCursor' highlight for insert and visual-exclusive modes
  "r-cr:hor20-CursorIM", -- Use 'CursorIM' for replace mode
}

-- ############################################################################
--                           End of Neovide section
-- ############################################################################

-- ############################################################################
--                         Provider Configuration
-- ############################################################################
-- Configure Python provider to use virtual environment with updated pynvim
vim.g.python3_host_prog = vim.fn.expand("~/.local/share/nvim-venv/bin/python")

-- Configure Node.js provider to use custom npm global directory
vim.g.node_host_prog = vim.fn.expand("~/.npm-global/lib/node_modules/neovim/bin/cli.js")

-- Disable unused language providers to reduce warnings
-- Uncomment any of these if you don't need the specific language support

vim.g.loaded_perl_provider = 0    -- Disable Perl provider
vim.g.loaded_ruby_provider = 0    -- Disable Ruby provider
-- vim.g.loaded_node_provider = 0    -- Disable Node.js provider (not recommended)
-- vim.g.loaded_python3_provider = 0 -- Disable Python provider (not recommended)

-- ############################################################################
--                      End of Provider Configuration  
-- ############################################################################
