local Viewport = require("sentiment.Viewport")
local Position = require("sentiment.Position")

---Efficient buffer reader.
---
---@class Chunk
---@field private viewport Viewport Area to operate on.
---@field private lines string[] Lines inside `viewport`.
local Chunk = {}
local metatable = { __index = Chunk }

---Create a new instance of `Chunk`.
---
---@param viewport Viewport Area to operate on.
---@param lines string[] Lines inside `viewport`.
---@return Chunk
function Chunk.new(viewport, lines)
  local instance = setmetatable({}, metatable)

  instance.viewport = viewport
  instance.lines = lines

  return instance
end

---Create a new instance of `Chunk` given a window.
---
---@param win window Window to take the visible area of.
---@return Chunk
function Chunk.from_win(win)
  local viewport = Viewport.from_win(win)
  local lines = vim.api.nvim_buf_get_lines(
    vim.api.nvim_win_get_buf(win),
    viewport.top - 1,
    viewport.bot,
    true
  )

  return Chunk.new(viewport, lines)
end

---Get the `n`th line.
---
---@param n integer Line index to get.
---@return string
function Chunk:line(n) return self.lines[n - self.viewport.top + 1] end

---Iterate over characters, ignoring newlines.
---
---```lua
---for position, char in chunk:chars() do
---  -- ...
---end
---```
---
---@return fun(): Position, string
function Chunk:chars()
  local position = Position.new(self.viewport.top, 0)

  return function()
    local line = self:line(position.line)
    position.character = position.character + 1
    if position.character > #line then
      position.line = position.line + 1
      if position.line > self.viewport.bot then
        ---@diagnostic disable-next-line: return-type-mismatch
        return nil, nil
      end

      line = self:line(position.line)
      position.character = 1
    end

    return position, line:sub(position.character, position.character)
  end
end

return Chunk
