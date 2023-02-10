---@class sentiment.Pair
---@field public opening tuple<number, number> Opening character.
---@field public closing tuple<number, number> Closing character.
local Pair = {}
Pair.__index = Pair

---Create a new instance of Pair.
---
---@param opening tuple<number, number>
---@param closing tuple<number, number>
---@return sentiment.Pair
function Pair.new(opening, closing)
  local instance = setmetatable({}, Pair)

  instance.opening = opening
  instance.closing = closing

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
    self.opening[1],
    self.opening[2],
    self.opening[2] + 1
  )

  vim.api.nvim_buf_add_highlight(
    bufnr,
    nsnr,
    "MatchParen",
    self.closing[1],
    self.closing[2],
    self.closing[2] + 1
  )
end

return Pair
