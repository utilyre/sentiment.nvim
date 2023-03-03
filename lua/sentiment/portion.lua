---@class Portion
---@field private win window Window to take the visible portion of.
---@field private buf buffer Inner buffer of `win`.
---@field private viewport tuple<integer, integer> Visible viewport of `win`.
---@field private lines string[] Lines inside `viewport`.
---@field private cursor tuple<integer, integer> Cursor position of `win`.
local Portion = {}

---Create a new instance of Portion.
---
---@param win window Window to take the visible portion of.
---@return Portion
function Portion.new(win)
  local instance = setmetatable({}, { __index = Portion })

  instance.win = win
  instance.buf = vim.api.nvim_win_get_buf(instance.win)
  instance.viewport = {
    vim.fn.line("w0", instance.win),
    vim.fn.line("w$", instance.win),
  }
  instance.lines = vim.api.nvim_buf_get_lines(
    instance.buf,
    instance.viewport[1] - 1,
    instance.viewport[2],
    true
  )
  instance.cursor = vim.api.nvim_win_get_cursor(instance.win)
  instance.cursor[2] = instance.cursor[2] + 1

  return instance
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
---@param reverse boolean Whether to iterate backwards.
---@return fun(): tuple<integer, integer>, string
function Portion:iter(reverse)
  local coefficient = reverse and -1 or 1

  local cursor = vim.deepcopy(self.cursor)
  cursor[2] = cursor[2] - coefficient

  return function()
    local line = self.lines[cursor[1] - self.viewport[1] + 1]
    cursor[2] = cursor[2] + coefficient
    if reverse and (cursor[2] < 1) or (cursor[2] > #line) then
      cursor[1] = cursor[1] + coefficient
      if
        reverse and (cursor[1] < self.viewport[1])
        or (cursor[1] > self.viewport[2])
      then
        ---@diagnostic disable-next-line: missing-return-value, return-type-mismatch
        return nil
      end

      line = self.lines[cursor[1] - self.viewport[1] + 1]
      cursor[2] = reverse and #line or 1
    end

    return cursor, line:sub(cursor[2], cursor[2])
  end
end

return Portion
