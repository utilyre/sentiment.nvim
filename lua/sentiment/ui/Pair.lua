---Pair highlighter to reduce boilerplate.
---
---# Examples
---
---```lua
---local Pair = require("sentiment.ui.Pair")
---
----- instantiate it
---local pair = Pair.new({ 5, 10 }, { 30, 1 })
---
----- draw it inside the current buffer with a newly created namespace
---pair:draw(0, 0)
---```
---
---@class Pair
---@field public left tuple<integer, integer>|nil Left hand side opening character position in `(row, col)` format.
---@field public right tuple<integer, integer>|nil Right hand side closing character position in `(row, col)` format.
local Pair = {}

---Create a new instance of `Pair`.
---
---@param left? tuple<integer, integer> Left hand side opening character position in `(row, col)` format.
---@param right? tuple<integer, integer> Right hand side closing character position in `(row, col)` format.
---@return Pair
function Pair.new(left, right)
  local instance = setmetatable({}, { __index = Pair })

  instance.left = left
  instance.right = right

  return instance
end

---Highlight opening and closing characters.
---
---@param buf buffer Buffer to be drawn in.
---@param ns namespace Namespace to be drawn in.
function Pair:draw(buf, ns)
  if self.left ~= nil then
    vim.api.nvim_buf_add_highlight(
      buf,
      ns,
      "MatchParen",
      self.left[1] - 1,
      self.left[2] - 1,
      self.left[2]
    )
  end

  if self.right ~= nil then
    vim.api.nvim_buf_add_highlight(
      buf,
      ns,
      "MatchParen",
      self.right[1] - 1,
      self.right[2] - 1,
      self.right[2]
    )
  end
end

return Pair
