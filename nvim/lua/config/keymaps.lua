-- Keymaps — debloated
-- Keeps: navigation, copy/paste, search/replace, tmux, file management helpers

local M = {}

-- ─── Quit / Restart ──────────────────────────────────────────────────────────

vim.keymap.set({ "n", "v", "i" }, "<M-q>", "<cmd>wqa<cr>", { desc = "[P]Quit All" })

-- Restart Neovim (tmux-aware: close any side pane first)
vim.keymap.set({ "n", "v", "i" }, "<M-R>", function()
  vim.cmd("wall")
  local has_panes = vim.fn.system("tmux list-panes | wc -l"):gsub("%s+", "") ~= "1"
  if has_panes then
    vim.fn.system("tmux kill-pane -t :.+")
  end
  vim.cmd("qall")
end, { desc = "[P]Restart Neovim" })

-- Disable accidental <M-r> (would replace a char)
vim.keymap.set({ "n", "v", "i" }, "<M-r>", "<Nop>", { desc = "[P]Disabled M-r" })

-- ─── Escape ───────────────────────────────────────────────────────────────────

vim.keymap.set("i", "<Esc>", function()
  vim.cmd("stopinsert")
  vim.defer_fn(function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
  end, 1)
end, { desc = "Exit insert mode", noremap = true, silent = true })

vim.keymap.set("n", "<Esc>", function()
  if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
  vim.cmd("nohlsearch")
end, { desc = "Force normal mode / clear search", noremap = true, silent = true })

-- ─── Protected movement (prevents accidental insert on stray key sequences) ──

local function safe_move(key)
  return function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    vim.cmd("normal! " .. key)
  end
end

vim.keymap.set("n", "j", safe_move("j"), { desc = "Move down", noremap = true, silent = true })
vim.keymap.set("n", "k", safe_move("k"), { desc = "Move up",   noremap = true, silent = true })
vim.keymap.set("n", "h", safe_move("h"), { desc = "Move left", noremap = true, silent = true })
vim.keymap.set("n", "l", safe_move("l"), { desc = "Move right",noremap = true, silent = true })

-- ─── Scrolling ────────────────────────────────────────────────────────────────

local scroll_pct = 0.35
vim.keymap.set("n", "<C-d>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_pct)
  vim.cmd("normal! " .. lines .. "jzz")
end, { noremap = true, silent = true, desc = "Scroll down 35%" })

vim.keymap.set("n", "<C-u>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_pct)
  vim.cmd("normal! " .. lines .. "kzz")
end, { noremap = true, silent = true, desc = "Scroll up 35%" })

-- ─── Line navigation ──────────────────────────────────────────────────────────

vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "[P]Go to beginning of line" })
vim.keymap.set("n",          "gl", "$", { desc = "[P]Go to end of line" })
vim.keymap.set("v",          "gl", "$h", { desc = "[P]Go to end of line (visual)" })

-- ─── Delete without yanking ──────────────────────────────────────────────────
-- Send d/x deletes to the black hole register; use y/yy/ciw etc. to yank.

vim.keymap.set({ "n", "v" }, "d",  [["_d]],  { desc = "Delete (no yank)", noremap = true })
vim.keymap.set("n",          "dd", [["_dd]], { desc = "Delete line (no yank)", noremap = true })
vim.keymap.set("n",          "D",  [["_D]],  { desc = "Delete to EOL (no yank)", noremap = true })
vim.keymap.set({ "n", "v" }, "x",  [["_x]],  { desc = "Delete char (no yank)", noremap = true })
vim.keymap.set({ "n", "v" }, "X",  [["_X]],  { desc = "Delete char back (no yank)", noremap = true })

-- ─── Copy / Yank ──────────────────────────────────────────────────────────────

-- Yank selection to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "[P]Yank to system clipboard" })

-- Yank to end of line
vim.keymap.set("n", "Y", "y$", { desc = "[P]Yank to end of line" })

-- ─── Visual mode line moving ──────────────────────────────────────────────────

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "[P]Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "[P]Move line up" })

-- Keep cursor at start when joining lines
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- Keep search results centred
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- ─── Search / Replace ─────────────────────────────────────────────────────────

-- grug-far: search & replace in current file
vim.keymap.set({ "v", "n" }, "<leader>s1",
  '<cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<cr>',
  { noremap = true, silent = true, desc = "Search/replace in current file" })

-- Replace word under cursor globally in file
vim.keymap.set("n", "<leader>su",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "[P]Replace current word globally" })

-- Replace current word with UPPERCASE version
vim.keymap.set("n", "<leader>sU",
  [[:%s/\<<C-r><C-w>\>/<C-r>=toupper(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "[P]Replace word with UPPERCASE" })

-- Replace current word with lowercase version
vim.keymap.set("n", "<leader>sL",
  [[:%s/\<<C-r><C-w>\>/<C-r>=tolower(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "[P]Replace word with lowercase" })

-- ─── Buffer navigation ────────────────────────────────────────────────────────

-- Quickly alternate between last 2 files
vim.keymap.set({ "n", "i", "v" }, "<M-BS>", "<cmd>e #<cr>", { desc = "[P]Alternate buffer" })

-- leader+TAB: same alternate-buffer jump (normal-mode shortcut)
vim.keymap.set("n", "<leader><TAB>", function()
  if vim.fn.bufnr("#") == -1 then
    vim.notify("No alternate buffer", vim.log.levels.WARN)
  else
    vim.cmd("e #")
  end
end, { desc = "[P]Alternate buffer" })

-- ─── LazyGit ─────────────────────────────────────────────────────────────────

if vim.fn.executable("lazygit") == 1 then
  vim.keymap.set("n", "<M-g>", function()
    Snacks.lazygit({ cwd = LazyVim.root.git() })
  end, { desc = "Lazygit (Root Dir)" })
end

-- ─── Noice (notification UI) ──────────────────────────────────────────────────

vim.keymap.set({ "n", "v", "i" }, "<M-h>", function()
  require("noice").cmd("all")
end, { desc = "[P]Noice History" })

vim.keymap.set({ "n", "v", "i" }, "<M-D>", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss All Notifications" })

-- ─── Tmux pane toggle ─────────────────────────────────────────────────────────
-- Opens/toggles a zsh pane in the current file's directory.
-- Also used by mini-files to open highlighted dir in a tmux pane.

M.tmux_pane_function = function(dir)
  local auto_cd_to_new_dir = true
  local pane_direction = vim.g.tmux_pane_direction or "right"
  local pane_size   = (pane_direction == "right") and 60 or 15
  local move_key    = (pane_direction == "right") and "C-l" or "C-k"
  local split_cmd   = (pane_direction == "right") and "-h" or "-v"
  local file_dir    = dir or vim.fn.expand("%:p:h")
  local has_panes   = vim.fn.system("tmux list-panes | wc -l"):gsub("%s+", "") ~= "1"
  local is_zoomed   = vim.fn.system("tmux display-message -p '#{window_zoomed_flag}'"):gsub("%s+", "") == "1"
  local escaped_dir = file_dir:gsub("'", "'\\''")

  if has_panes then
    if is_zoomed then
      if auto_cd_to_new_dir and vim.g.tmux_pane_dir ~= escaped_dir then
        vim.fn.system("tmux send-keys -t :.+ 'cd \"" .. escaped_dir .. "\"' Enter")
        vim.g.tmux_pane_dir = escaped_dir
      end
      vim.fn.system("tmux resize-pane -Z")
      vim.fn.system("tmux send-keys " .. move_key)
    else
      vim.fn.system("tmux resize-pane -Z")
    end
  else
    if vim.g.tmux_pane_dir == nil then
      vim.g.tmux_pane_dir = escaped_dir
    end
    vim.fn.system(
      "tmux split-window " .. split_cmd .. " -l " .. pane_size
        .. " 'cd \"" .. escaped_dir .. "\" && DISABLE_PULL=1 zsh'"
    )
    vim.fn.system("tmux send-keys " .. move_key)
  end
end

vim.keymap.set("n", "<leader>f.", function()
  M.tmux_pane_function()
end, { desc = "[P]Toggle tmux pane at current dir" })

vim.keymap.set({ "n", "i", "t" }, "<M-t>", function()
  M.tmux_pane_function()
end, { desc = "[P]Toggle tmux pane (Alt-t)" })

-- ─── Toggles (spell + harper) ────────────────────────────────────────────────

vim.keymap.set("n", "<leader>ts", function()
  vim.opt_local.spell = not vim.opt_local.spell:get()
  vim.notify("Spell " .. (vim.opt_local.spell:get() and "on" or "off"), vim.log.levels.INFO)
end, { desc = "Toggle spell check" })

vim.keymap.set("n", "<leader>th", function()
  if vim.lsp.is_enabled("harper_ls") then
    vim.lsp.enable("harper_ls", false)
    vim.notify("harper_ls off", vim.log.levels.INFO)
  else
    vim.lsp.enable("harper_ls")
    vim.notify("harper_ls on", vim.log.levels.INFO)
  end
end, { desc = "[P]Toggle harper grammar check" })

-- ─── Executable toggle ────────────────────────────────────────────────────────

vim.keymap.set("n", "<leader>fx", function()
  local file = vim.fn.expand("%")
  local perms = vim.fn.getfperm(file)
  local is_executable = string.match(perms, "x", -1) ~= nil
  local escaped_file = vim.fn.shellescape(file)
  if is_executable then
    vim.cmd("silent !chmod -x " .. escaped_file)
    vim.notify("Removed executable permission", vim.log.levels.INFO)
  else
    vim.cmd("silent !chmod +x " .. escaped_file)
    vim.notify("Added executable permission", vim.log.levels.INFO)
  end
end, { desc = "Toggle executable permission" })

-- ─── Run script in tmux pane ──────────────────────────────────────────────────

vim.keymap.set("n", "<leader>cb", function()
  local file = vim.fn.expand("%")
  local first_line = vim.fn.getline(1)
  if string.match(first_line, "^#!/") then
    local escaped_file = vim.fn.shellescape(file)
    vim.cmd(
      "silent !tmux split-window -h -l 60 'bash -c \""
        .. escaped_file
        .. "; echo; echo Press any key to exit...; read -n 1; exit\"'"
    )
  else
    vim.cmd("echo 'Not a script. Shebang line not found.'")
  end
end, { desc = "[P]Run script in tmux pane" })

return M
