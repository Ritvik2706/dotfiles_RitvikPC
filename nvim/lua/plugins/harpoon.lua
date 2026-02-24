-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
-- Mark up to 4 files and jump between them instantly.
--
-- Keymaps:
--   <leader>a   — smart-mark: skip if already marked, fill empty slot, else replace slot 1
--   <leader>A   — unmark current file
--   <leader>hc  — clear all 4 slots
--   <M-e>       — open Snacks picker menu with file preview
--   <M-a/s/d/f> — jump directly to harpoon slot 1 / 2 / 3 / 4

local MAX_SLOTS = 4
local SLOT_KEYS = { "a", "s", "d", "f" }

-- One-line summary of all 4 slots:  [a] init.lua   [s] ·   [d] foo.lua   [f] ·
local function slots_summary(list)
  local parts = {}
  for i, key in ipairs(SLOT_KEYS) do
    local item = list:get(i)
    local name = item and vim.fn.fnamemodify(item.value, ":t") or "·"
    table.insert(parts, string.format("[%s] %s", key, name))
  end
  return table.concat(parts, "   ")
end

-- Smart-mark logic:
--   1. Already in list — notify and do nothing
--   2. Empty slot exists — fill it
--   3. All slots full — evict slot 1 (shift 2→1, 3→2, 4→3), add new at slot 4
local function smart_mark(list)
  local current_abs = vim.fn.expand("%:p")
  local fname = vim.fn.expand("%:t")

  -- 1. Already marked in slots 1-4?
  for i = 1, MAX_SLOTS do
    local item = list:get(i)
    if item and vim.fn.fnamemodify(item.value, ":p") == current_abs then
      vim.notify(
        slots_summary(list),
        vim.log.levels.INFO,
        { title = "󱣀 Harpoon  —  already in [" .. SLOT_KEYS[i] .. "]" }
      )
      return
    end
  end

  -- Clamp list to MAX_SLOTS in case of stale entries from a previous config
  while list:length() > MAX_SLOTS do
    list:remove_at(list:length())
  end

  -- 2. Space available — append into next slot
  local len = list:length()
  if len < MAX_SLOTS then
    list:add()
    local new_len = list:length()
    local slot_key = SLOT_KEYS[new_len] or tostring(new_len)
    vim.notify(
      slots_summary(list),
      vim.log.levels.INFO,
      { title = "󱣀 Harpoon  —  marked " .. fname .. " → [" .. slot_key .. "]" }
    )
    return
  end

  -- 3. All full — evict slot 1, shift remaining left, add new at end
  local evicted = list:get(1)
  local evicted_name = evicted and vim.fn.fnamemodify(evicted.value, ":t") or "?"
  list:remove_at(1)
  list:add()
  vim.notify(
    slots_summary(list),
    vim.log.levels.WARN,
    { title = "󱣀 Harpoon  —  replaced [a] " .. evicted_name .. " with " .. fname }
  )
end

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    {
      "<leader>a",
      function() smart_mark(require("harpoon"):list()) end,
      desc = "[H]Harpoon: smart-mark file",
    },
    {
      "<leader>A",
      function()
        local list = require("harpoon"):list()
        local current = vim.fn.expand("%:p")
        for i = 1, list:length() do
          local item = list:get(i)
          if item and vim.fn.fnamemodify(item.value, ":p") == current then
            local slot = SLOT_KEYS[i] or tostring(i)
            list:remove_at(i)
            vim.notify(
              slots_summary(list),
              vim.log.levels.WARN,
              { title = "󱣀 Harpoon  —  removed [" .. slot .. "] " .. vim.fn.expand("%:t") }
            )
            return
          end
        end
        vim.notify("Not in harpoon list", vim.log.levels.WARN, { title = "󱣀 Harpoon" })
      end,
      desc = "[H]Harpoon: unmark file",
    },
    {
      "<leader>hc",
      function()
        local list = require("harpoon"):list()
        list:clear()
        vim.notify(
          "[a] ·   [s] ·   [d] ·   [f] ·",
          vim.log.levels.WARN,
          { title = "󱣀 Harpoon  —  cleared all slots" }
        )
      end,
      desc = "[H]Harpoon: clear all slots",
    },
    {
      "<M-e>",
      function()
        local list = require("harpoon"):list()
        if list:length() == 0 then
          vim.notify("Harpoon list is empty", vim.log.levels.INFO, { title = "󱣀 Harpoon" })
          return
        end
        Snacks.picker({
          title = "󱣀 Harpoon",
          finder = function()
            local fresh = {}
            local l = require("harpoon"):list()
            for i = 1, math.min(l:length(), MAX_SLOTS) do
              local entry = l:get(i)
              if entry then
                local abs = vim.fn.fnamemodify(entry.value, ":p")
                table.insert(fresh, {
                  text = string.format("[M-%s]  %s", SLOT_KEYS[i] or i, vim.fn.fnamemodify(abs, ":~:.")),
                  file = abs,
                  slot = i,
                })
              end
            end
            return fresh
          end,
          format = function(item)
            local key = SLOT_KEYS[item.slot] or tostring(item.slot)
            return {
              { " [M-" .. key .. "] ", "Special" },
              { vim.fn.fnamemodify(item.file, ":t") .. " ", "Normal" },
              { vim.fn.fnamemodify(item.file, ":~:."), "Comment" },
            }
          end,
          preview = "file",
          layout = "ivy",
          on_show = function() vim.cmd.startinsert() end,
          confirm = function(picker, item)
            picker:close()
            require("harpoon"):list():select(item.slot)
          end,
          actions = {
            harpoon_remove = function(picker, item)
              local fname = vim.fn.fnamemodify(item.file, ":t")
              local slot = SLOT_KEYS[item.slot] or tostring(item.slot)
              require("harpoon"):list():remove_at(item.slot)
              vim.notify(
                slots_summary(require("harpoon"):list()),
                vim.log.levels.WARN,
                { title = "� Harpoon  —  removed [" .. slot .. "] " .. fname }
              )
              picker:find()
            end,
          },
          win = {
            input = { keys = { ["dd"] = "harpoon_remove" } },
            list  = { keys = { ["dd"] = "harpoon_remove" } },
          },
        })
      end,
      desc = "[H]Harpoon: open menu",
    },
    {
      "<M-a>",
      function() require("harpoon"):list():select(1) end,
      desc = "[H]Harpoon: jump to slot 1",
    },
    {
      "<M-s>",
      function() require("harpoon"):list():select(2) end,
      desc = "[H]Harpoon: jump to slot 2",
    },
    {
      "<M-d>",
      function() require("harpoon"):list():select(3) end,
      desc = "[H]Harpoon: jump to slot 3",
    },
    {
      "<M-f>",
      function() require("harpoon"):list():select(4) end,
      desc = "[H]Harpoon: jump to slot 4",
    },
  },
  config = function()
    require("harpoon"):setup()
  end,
}
