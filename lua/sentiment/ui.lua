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
    if config.is_pair(not left, char) then
      remaining = remaining + 1
    elseif config.is_pair(left, char) then
      if remaining == 0 then return cursor end
      remaining = remaining - 1
    end
  end

  return nil
end

---Calculate and highlight the found pair.
---
---@param win? window
function M.render(win)
  win = win or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  if not config.is_buffer_included(buf) then return end

  local portion = Portion.new(win, config.get_limit())
  local under_cursor = portion:get_current_char()

  local left = nil
  local right = nil
  if config.is_pair(true, under_cursor) then
    left = portion.cursor
    right = find_pair(false, portion)
  elseif config.is_pair(false, under_cursor) then
    left = find_pair(true, portion)
    right = portion.cursor
  else
    left = find_pair(true, portion)
    right = find_pair(false, portion)
  end

  local ns = vim.api.nvim_create_namespace(NAMESPACE_PAIR)
  local pair = Pair.new(left, right)

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  pair:draw(buf, ns)
end

return M
