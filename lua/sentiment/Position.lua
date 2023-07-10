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

return Position
