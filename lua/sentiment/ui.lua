local config = require("sentiment.config")
local Portion = require("sentiment.ui.Portion")
local Pair = require("sentiment.ui.Pair")

local NAMESPACE_PAIR = "sentiment.pair"

local M = {}

---Find the first occurrence of a pair.
---
---@param left boolean Whether to look for a left pair.
---@param portion Portion Portion to be searched.
---@return tuple<integer, integer>|nil
local function find_pair(left, portion)
  local remaining = 0

  for cursor, char in portion:iter(left) do
    if config.is_matchpair(not left, char) then
      remaining = remaining + 1
    elseif config.is_matchpair(left, char) then
      if remaining == 0 then return cursor end
      remaining = remaining - 1
    end
  end

  return nil
end

---Clear pair highlights.
---
---@param buf? buffer
function M.clear(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local ns = vim.api.nvim_create_namespace(NAMESPACE_PAIR)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
end

---Calculate and update the highlighted pair.
---
---@param win? window
function M.update(win)
  win = win or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  if not config.is_buffer_included(buf) then return end

  local portion = Portion.new(win)
  local under_cursor = portion:get_current_char()

  local left = nil
  local right = nil
  if config.is_matchpair(true, under_cursor) then
    left = portion.cursor
    right = find_pair(false, portion)
  elseif config.is_matchpair(false, under_cursor) then
    left = find_pair(true, portion)
    right = portion.cursor
  else
    left = find_pair(true, portion)
    right = find_pair(false, portion)
  end

  M.clear(buf)
  local pair = Pair.new(left, right)
  pair:draw(buf, vim.api.nvim_create_namespace(NAMESPACE_PAIR))
end

return M
