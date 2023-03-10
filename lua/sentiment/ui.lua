local config = require("sentiment.config")
local Portion = require("sentiment.ui.Portion")
local Pair = require("sentiment.ui.Pair")

local VARIABLE_VIEWPORT = "sentiment.viewport"
local NAMESPACE_PAIR = "sentiment.pair"

local M = {}

---Clear `Pair` highlights.
---
---@param buf? buffer Buffer to be cleared.
function M.clear(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  local ns = vim.api.nvim_create_namespace(NAMESPACE_PAIR)
  local ok, viewport = pcall(vim.api.nvim_buf_get_var, buf, VARIABLE_VIEWPORT)
  if not ok then return end

  vim.api.nvim_buf_clear_namespace(buf, ns, viewport[1] - 1, viewport[2])
end

---Calculate and draw the found `Pair`.
---
---@param win? window Window to be rendered inside.
function M.render(win)
  win = win or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  if not config.is_buffer_included(buf) then return end

  local portion = Portion.new(win, config.get_limit())
  local under_cursor = portion:get_current_char()
  local pair = Pair.new()

  local right = config.get_right_by_left(under_cursor)
  local left = config.get_left_by_right(under_cursor)
  if right ~= nil then
    pair.left = portion:get_cursor()

    local remainings = 0
    for cursor, char in portion:iter(false) do
      if char == under_cursor then
        remainings = remainings + 1
      elseif char == right then
        if remainings == 0 then
          pair.right = cursor
          break
        end

        remainings = remainings - 1
      end
    end
  elseif left ~= nil then
    pair.right = portion:get_cursor()

    local remaining = 0
    for cursor, char in portion:iter(true) do
      if char == under_cursor then
        remaining = remaining + 1
      elseif char == left then
        if remaining == 0 then
          pair.left = cursor
          break
        end

        remaining = remaining - 1
      end
    end
  else
    local found_left = nil
    local found_right = nil

    local remaining = 0
    for cursor, char in portion:iter(false) do
      if config.get_right_by_left(char) ~= nil then
        remaining = remaining + 1
      elseif config.get_left_by_right(char) ~= nil then
        if remaining == 0 then
          found_left = config.get_left_by_right(char)
          found_right = char
          pair.right = cursor
          break
        end

        remaining = remaining - 1
      end
    end

    remaining = 0
    if found_left == nil then
      for cursor, char in portion:iter(true) do
        if config.get_left_by_right(char) then
          remaining = remaining + 1
        elseif config.get_right_by_left(char) then
          if remaining == 0 then
            pair.left = cursor
            break
          end

          remaining = remaining - 1
        end
      end
    else
      for cursor, char in portion:iter(true) do
        if char == found_right then
          remaining = remaining + 1
        elseif char == found_left then
          if remaining == 0 then
            pair.left = cursor
            break
          end

          remaining = remaining - 1
        end
      end
    end
  end

  M.clear(buf)
  vim.api.nvim_buf_set_var(
    buf,
    VARIABLE_VIEWPORT,
    { portion:get_top(), portion:get_bottom() }
  )

  pair:draw(buf, vim.api.nvim_create_namespace(NAMESPACE_PAIR))
end

return M
