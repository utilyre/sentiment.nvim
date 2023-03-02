---@class Pair
---@field public left tuple<number, number> Left hand side opening character position in `(row, col)` format.
---@field public right tuple<number, number> Right hand side closing character position in `(row, col)` format.
local Pair = {}

---Create a new instance of Pair.
---
---@param left tuple<number, number> Left hand side opening character position in `(row, col)` format.
---@param right tuple<number, number> Right hand side closing character position in `(row, col)` format.
---@return Pair
function Pair.new(left, right)
  local instance = setmetatable({}, { __index = Pair })

  instance.left = left
  instance.right = right

  return instance
end

---Highlight opening and closing characters.
---
---@param buf buffer
---@param ns namespace
function Pair:draw(buf, ns)
  vim.api.nvim_buf_add_highlight(
    buf,
    ns,
    "MatchParen",
    self.left[1] - 1,
    self.left[2] - 1,
    self.left[2]
  )

  vim.api.nvim_buf_add_highlight(
    buf,
    ns,
    "MatchParen",
    self.right[1] - 1,
    self.right[2] - 1,
    self.right[2]
  )
end

return Pair
