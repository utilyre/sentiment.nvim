---@class Portion
---@field private viewport tuple<integer, integer> Visible viewport in (top, bottom) format.
---@field private lines string[] Lines inside `viewport`.
---@field private cursor tuple<integer, integer> Cursor position in (row, col) format.
local Portion = {}

---Create a new instance of Portion.
---
---@param win window Window to take the visible portion of.
---@return Portion
function Portion.new(win)
  win = win == 0 and vim.api.nvim_get_current_win() or win
  local buf = vim.api.nvim_win_get_buf(win)

  local instance = setmetatable({}, { __index = Portion })

  instance.viewport = {
    vim.fn.line("w0", win),
    vim.fn.line("w$", win),
  }
  instance.lines = vim.api.nvim_buf_get_lines(
    buf,
    instance.viewport[1] - 1,
    instance.viewport[2],
    true
  )
  instance.cursor = vim.api.nvim_win_get_cursor(win)
  instance.cursor[2] = instance.cursor[2] + 1

  return instance
end

---Get the line under the cursor.
---
---@param cursor? tuple<integer, integer>
---@return string
function Portion:get_current_line(cursor)
  cursor = cursor or self.cursor
  return self.lines[cursor[1] - self.viewport[1] + 1]
end

---Get the character under the cursor.
---
---@param cursor? tuple<integer, integer>
---@return string
function Portion:get_current_char(cursor)
  cursor = cursor or self.cursor
  return self:get_current_line(cursor):sub(cursor[2], cursor[2])
end

---Iterate over all characters of the Portion, ignoring newline characters.
---
---```lua
---local portion = Portion.new(--[[ ... ]])
---for cursor, char in portion:iter(false) do
---  -- ...
---end
---```
---
---@param reversed boolean Whether to iterate backwards.
---@return fun(): tuple<integer, integer>, string
function Portion:iter(reversed)
  local coefficient = reversed and -1 or 1

  local cursor = vim.deepcopy(self.cursor)
  cursor[2] = cursor[2] - coefficient

  return function()
    local line = self:get_current_line(cursor)
    cursor[2] = cursor[2] + coefficient
    if reversed and (cursor[2] < 1) or (cursor[2] > #line) then
      cursor[1] = cursor[1] + coefficient
      if
        reversed and (cursor[1] < self.viewport[1])
        or (cursor[1] > self.viewport[2])
      then
        ---@diagnostic disable-next-line: missing-return-value, return-type-mismatch
        return nil
      end

      line = self:get_current_line(cursor)
      cursor[2] = reversed and #line or 1
    end

    return cursor, line:sub(cursor[2], cursor[2])
  end
end

return Portion
