---Vector-like character position.
---
---@class Position
---@field public line integer Index of line.
---@field public character integer Index of character.
local Position = {}
local metatable = { __index = Position }

---Create a new instance of `Position`.
---
---@param line integer Index of line.
---@param character integer Index of character.
---@return Position
function Position.new(line, character)
  local instance = setmetatable({}, metatable)

  instance.line = line
  instance.character = character

  return instance
end

---@param a Position
---@param b Position
---@return boolean
function metatable.__lt(a, b)
  if a.line < b.line then
    return true
  elseif a.line > b.line then
    return false
  end

  return a.character < b.character
end

---@param a Position
---@param b Position
---@return boolean
function metatable.__le(a, b) return a < b or a == b end

---@param a Position
---@param b Position
---@return boolean
function metatable.__eq(a, b)
  return a.line == b.line and a.character == b.character
end

return Position
