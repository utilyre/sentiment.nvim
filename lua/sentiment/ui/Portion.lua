---@class Portion
---@field private cursor tuple<integer, integer> Cursor position in `(row, col)` format.
---@field private viewport tuple<integer, integer> Visible viewport in `(top, bottom)` format.
---@field private lines string[] Lines inside `viewport`.
local Portion = {}

---Create a new instance of `Portion`.
---
---@param win window Window to take the visible portion of.
---@param limit integer Maximum amount of lines around the cursor to be processed.
---@return Portion
function Portion.new(win, limit)
  local instance = setmetatable({}, { __index = Portion })

  instance.cursor = vim.api.nvim_win_get_cursor(win)
  instance.cursor[2] = instance.cursor[2] + 1

  instance.viewport = {
    vim.fn.line("w0", win),
    vim.fn.line("w$", win),
  }
  if instance.cursor[1] - instance.viewport[1] > limit then
    instance.viewport[1] = instance.cursor[1] - limit
  end
  if instance.viewport[2] - instance.cursor[1] > limit then
    instance.viewport[2] = instance.cursor[1] + limit
  end

  instance.lines = vim.api.nvim_buf_get_lines(
    vim.api.nvim_win_get_buf(win),
    instance.viewport[1] - 1,
    instance.viewport[2],
    true
  )

  return instance
end

---Get cursor position in `(row, col)` format.
---
---@return tuple<integer, integer>
function Portion:get_cursor() return vim.deepcopy(self.cursor) end

---Get the top position.
---
---@return integer
function Portion:get_top() return self.viewport[1] end

---Get the bottom position.
---
---@return integer
function Portion:get_bottom() return self.viewport[2] end

---Get the nth line.
---
---@private
---@param row integer Line number to get.
---@return string
function Portion:get_line(row)
  return self.lines[row - self.viewport[1] + 1]
end

---Get the character under the cursor.
---
---@return string
function Portion:get_current_char()
  return self:get_line(self.cursor[1]):sub(self.cursor[2], self.cursor[2])
end

---Iterate over all characters of the `Portion`, ignoring newline characters.
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

  return function()
    local line = self:get_line(cursor[1])
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

      line = self:get_line(cursor[1])
      cursor[2] = reversed and #line or 1
    end

    return cursor, line:sub(cursor[2], cursor[2])
  end
end

return Portion
