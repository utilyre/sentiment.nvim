---@class sentiment.Pair
---@field public left tuple<number, number> Left hand side opening character position in `(line, character)` format.
---@field public right tuple<number, number> Right hand side closing character position in `(line, character)` format.
local Pair = {}
Pair.__index = Pair

---Create a new instance of Pair.
---
---@param left tuple<number, number> Left hand side opening character position in `(line, character)` format.
---@param right tuple<number, number> Right hand side closing character position in `(line, character)` format.
---@return sentiment.Pair
function Pair.new(left, right)
  local instance = setmetatable({}, Pair)

  instance.left = left
  instance.right = right

  return instance
end

---Highlight opening and closing characters.
---
---@param bufnr buffer
---@param nsnr namespace
function Pair:draw(bufnr, nsnr)
  vim.api.nvim_buf_add_highlight(
    bufnr,
    nsnr,
    "MatchParen",
    self.left[1],
    self.left[2],
    self.left[2] + 1
  )

  vim.api.nvim_buf_add_highlight(
    bufnr,
    nsnr,
    "MatchParen",
    self.right[1],
    self.right[2],
    self.right[2] + 1
  )
end

return Pair
