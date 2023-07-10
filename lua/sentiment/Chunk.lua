local Region = require("sentiment.Region")
local Position = require("sentiment.Position")

---Efficient buffer reader.
---
---@class Chunk
---@field private region Region Area to operate on.
---@field private lines string[] Lines inside `region`.
local Chunk = {}
local metatable = { __index = Chunk }

---Create a new instance of `Chunk`.
---
---@param region Region Area to operate on.
---@param lines string[] Lines inside `region`.
---@return Chunk
function Chunk.new(region, lines)
  local instance = setmetatable({}, metatable)

  instance.region = region
  instance.lines = lines

  return instance
end

---Create a new instance of `Chunk` given a window.
---
---@param win window Window to take the visible area of.
---@return Chunk
function Chunk.from_win(win)
  local region = Region.from_win(win)
  local lines = vim.api.nvim_buf_get_lines(
    vim.api.nvim_win_get_buf(win),
    region.top - 1,
    region.bot,
    true
  )

  return Chunk.new(region, lines)
end

---Get the `n`th line.
---
---@param n integer Line index to get.
---@return string|nil
function Chunk:line(n) return self.lines[n - self.region.top + 1] end

---Iterate over characters, ignoring newlines.
---
---NOTE: There's no guarantee for yielded values to stay the same after each
---iteration.
---
---```lua
---for position, char in chunk:chars() do
---  -- ...
---end
---```
---
---@return fun(): Position, string
function Chunk:chars()
  local position = Position.new(self.region.top, 0)

  return function()
    local line = self:line(position.line)
    position.character = position.character + 1
    if position.character > #line then
      position.line = position.line + 1
      if position.line > self.region.bot then
        ---@diagnostic disable-next-line: return-type-mismatch
        return nil, nil
      end

      line = self:line(position.line)
      position.character = 1
    end

    ---@cast line -nil
    return position, line:sub(position.character, position.character)
  end
end

return Chunk
