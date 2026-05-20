# Neovim Config — Features & Keymaps Reference

Quick reference for everything added or fixed in this config.

---

## Mini.files — Directory & File Management

**Open mini.files**

| Key | Action |
|-----|--------|
| `<leader>e` | Open mini.files at the current file |
| `<leader>E` | Open mini.files at the project root (cwd) |

**Navigation inside mini.files**

| Key | Action |
|-----|--------|
| `l` | Enter directory / preview file |
| `<CR>` | Open file (closes mini.files) |
| `h` | Go up one level (shows all siblings) |
| `H` | Go up one level (shows only one item to the right) |
| `<BS>` | Reset to starting directory |
| `.` | Reveal cwd in the panel |
| `<Esc>` | Close mini.files |
| `g?` | Show help |

**File operations inside mini.files**

Mini.files is an editable buffer. You edit the text to rename, move, or create things, then synchronize to apply.

| Key | Action |
|-----|--------|
| `s` | Synchronize — apply all pending changes (rename, move, create) |
| `yy` | Yank the current file/directory entry |
| `p` | Paste (duplicate) the yanked entry into the current directory |
| `<space>yy` | Copy the current file path to clipboard |
| `<space>yz` | Zip and copy the current file path to clipboard |
| `<space>p` | Paste a file from clipboard into current directory |
| `<M-c>` | Copy the relative path to clipboard |
| `<space>i` | Preview image with system image viewer |
| `<M-t>` | Open current directory in a tmux pane |
| `<` / `>` | Trim the left / right panel |

**Creating a new directory**

This is built-in — no extra setup needed:
1. Navigate to where you want the new directory
2. Press `o` to open a new line in insert mode
3. Type `dirname/` (the trailing slash tells mini.files it's a directory, not a file)
4. Press `<Esc>` then `s` to synchronize
5. Confirm with `y` when prompted

To create a file, do the same but without the trailing slash.

---

## Search — Snacks Picker

| Key | Action |
|-----|--------|
| `<leader>sg` | Grep inside the **current file's directory** (scoped, not project-wide) |
| `<leader>sf` | Find files in the project |
| `<leader>h` | Fuzzy buffer switcher |
| `<leader>gl` | Git log (commit browser) |

Inside any picker: `<M-j>`/`<M-k>` move through results, `<Esc>` closes.

---

## Git Workflow

### Gitsigns — per-hunk operations

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next / previous hunk |
| `]H` / `[H` | Last / first hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage entire buffer |
| `<leader>ghu` | Undo last stage |
| `<leader>ghR` | Reset entire buffer |
| `<leader>ghp` | Preview hunk inline |
| `<leader>ghb` | Blame current line (full) |
| `<leader>ghB` | Blame entire buffer |
| `<leader>ghd` | Diff this file (inline split) |
| `<leader>ghD` | Diff against last commit (`~`) |

### Diffview — multi-file diff & history

Diffview is for reviewing whole changesets and browsing file history, not per-hunk work.

| Key | Action |
|-----|--------|
| `<leader>gd` | Open diff against HEAD — shows all changed files side by side |
| `<leader>gD` | Close diffview |
| `<leader>gf` | History for the **current file** — scroll through every commit that touched it |
| `<leader>gF` | History for the **entire repo** |

Inside diffview:
- `Tab` / `S-Tab` — cycle between changed files in the panel
- `<CR>` — open a file's diff
- `q` — close

**When to use what:**
- `<leader>gh*` (gitsigns) → staging, resetting, blaming individual hunks
- `<leader>gd` (diffview) → reviewing the full changeset before committing
- `<leader>gf` (diffview file history) → understanding how a file evolved over time
- `<leader>gl` (snacks) → browsing commits by message / author
- `<M-g>` (lazygit) → full interactive git TUI

---

## Undo Tree

Neovim's undo is a **tree**, not a stack. If you type something, undo it, then type something different, the first version branches off and is normally unreachable. Undotree shows you the whole tree and lets you travel to any state.

With `undofile = true` set in your config, this history **persists across restarts**.

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo tree sidebar |

Inside the tree:
- `j` / `k` — navigate states
- `<CR>` — jump to that state in the file
- `q` — close
- The diff panel at the bottom shows what changed between states

---

## Symbol Outline

Shows every function, class, method, and variable in the current file as a navigable tree. Useful for large files or files in unfamiliar codebases.

| Key | Action |
|-----|--------|
| `<leader>cs` | Toggle symbol outline sidebar |

Inside the outline:
- `<CR>` — jump to that symbol (sidebar closes automatically)
- `h` / `l` — fold / unfold a class or namespace
- `zM` / `zR` — fold all / unfold all
- `q` or `<Esc>` — close without jumping

---

## Multiple Cursors — vim-visual-multi

> **Behaviour change:** `<C-n>` in normal mode now starts multi-cursor mode.

`<C-n>` selects the word under the cursor. From there:

| Key | Action |
|-----|--------|
| `<C-n>` | Add the next occurrence of the word as another cursor |
| `q` | Skip this occurrence and move to the next (no cursor added) |
| `Q` | Remove the cursor at the current position |
| `<Esc>` | Exit multi-cursor mode |

Once you have multiple cursors, all your normal operations work on every cursor at once — `c` to change, `d` to delete, `i` to insert, `>` / `<` to indent.

**Example:** rename `user_id` to `userId` across 8 places in a file:
1. Put cursor on `user_id`
2. Press `<C-n>` to select it
3. Keep pressing `<C-n>` until all 8 are selected (use `q` to skip any you don't want)
4. Press `c` then type `userId`

**vs. grug-far (`<leader>sr`):** Use visual-multi for quick same-file edits where you want to see each match. Use grug-far for project-wide or regex-based search and replace.

---

## Tab Out of Brackets — tabout

> **Behaviour change:** `<Tab>` in insert mode at a closing bracket now jumps past it.

If your cursor is inside `(`, `[`, `{`, `"`, `'`, or a backtick, pressing `<Tab>` exits it.

**Priority chain** — Tab does the first thing that applies:
1. Advance snippet field (if you're in an active blink.cmp snippet)
2. Jump past closing bracket (if cursor is inside a pair)
3. Insert a real tab (fallback)

`<S-Tab>` jumps backwards through brackets.

Your snippet navigation is unchanged. This only replaces the "do nothing useful with Tab" case.

---

## Hex Colour Preview — mini.hipatterns

No keymap needed — it's always on. Every hex colour string in any file is highlighted with its actual colour as the background. Works with both 6-digit (`#a48cf2`) and 3-digit shorthand (`#fff`).

Particularly useful in your `colors.lua` and `eldritch.lua` where dozens of colour values are defined.

---

## Harpoon — Quick File Bookmarks

Mark up to 4 files and jump between them instantly.

| Key | Action |
|-----|--------|
| `<leader>a` | Smart-mark current file into next free slot |
| `<leader>A` | Remove current file from harpoon |
| `<leader>hc` | Clear all 4 slots |
| `<M-e>` | Open harpoon picker (with file preview) |
| `<M-a>` | Jump to slot 1 |
| `<M-s>` | Jump to slot 2 |
| `<M-d>` | Jump to slot 3 |
| `<M-f>` | Jump to slot 4 |

Smart-mark logic: if the file is already marked, it tells you which slot. If there's a free slot, it fills it. If all 4 are full, it evicts slot 1 and shifts everything left.

Inside the harpoon picker, `dd` removes an entry.

---

## LSP Keymaps

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Show references |
| `gi` | Go to implementation |
| `gt` | Go to type definition |
| `K` | Hover documentation |
| `<C-k>` | Signature help (normal + insert mode) |
| `<leader>ca` | Code action |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file |
| `<leader>cd` | Show diagnostic float |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `<leader>th` | Toggle harper grammar check (markdown) |

---

## Search & Replace

| Key | Action |
|-----|--------|
| `<leader>sr` | Open grug-far (project-wide search/replace) |
| `<leader>s1` | Open grug-far scoped to the current file |
| `<leader>su` | Replace word under cursor globally in this file |
| `<leader>sU` | Replace word under cursor with UPPERCASE version |
| `<leader>sL` | Replace word under cursor with lowercase version |

Grug-far supports regex. Inside it, `<Esc>` closes.

---

## Buffer & Window Navigation

| Key | Action |
|-----|--------|
| `<leader>l` | Snipe buffer switcher (letter-hint jump) |
| `<leader>h` | Snacks fuzzy buffer picker |
| `<leader><TAB>` | Alternate between last two buffers |
| `<M-BS>` | Alternate buffer (insert/visual/normal) |
| `<C-h/j/k/l>` | Navigate between tmux panes and Neovim splits |

---

## Miscellaneous

| Key | Action |
|-----|--------|
| `<leader>e` | Open mini.files at current file |
| `<leader>E` | Open mini.files at cwd |
| `-` | Open oil.nvim (parent directory, supports `oil-ssh://host/`) |
| `<M-g>` | Lazygit |
| `<M-t>` | Toggle tmux pane at current directory |
| `<leader>f.` | Toggle tmux pane at current directory |
| `<leader>fx` | Toggle executable permission on current file |
| `<leader>cb` | Run current script in a tmux pane |
| `<leader>ts` | Toggle spell check |
| `<leader>th` | Toggle harper grammar check |
| `<M-h>` | Show notification history (noice) |
| `<M-D>` | Dismiss all notifications |
| `<M-q>` | Quit all |
| `<M-R>` | Restart Neovim |
| `<leader>y` | Yank selection to system clipboard |

---

## Notes

- `:grep <term>` now uses ripgrep and sends results to the quickfix list. This is separate from `<leader>sg` (Snacks picker).
- Undo history persists to `~/.local/state/nvim/undo/`. If you rename or move a file, the old undo history won't follow it.
- The `<leader>sg` search is scoped to the **current file's directory**, not the whole project. For project-wide grep use `<leader>sr` (grug-far).
