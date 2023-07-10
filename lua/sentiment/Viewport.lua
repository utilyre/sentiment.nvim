---Visible area of buffer.
---
---@class Viewport
---@field public top integer Number of the very first visible line.
---@field public bot integer Number of the very last visible line.
local Viewport = {}
local metatable = { __index = Viewport }

---Create a new instance of `Viewport`.
---
---# Errors
---
---Throws if `top` is greater than `bot`.
---
---@param top integer Number of the very first visible line.
---@param bot integer Number of the very last visible line.
---@return Viewport
function Viewport.new(top, bot)
  assert(top < bot, "`top` must be less than `bot`")

  local instance = setmetatable({}, metatable)

  instance.top = top
  instance.bot = bot

  return instance
end

---Create a new instance of `Viewport` given a window.
---
---@param win window Window to take the visible area of.
---@return Viewport
function Viewport.with_win(win)
  return Viewport.new(vim.fn.line("w0", win), vim.fn.line("w$", win))
end

---Returns `Viewport`'s length.
---
---@return integer
function Viewport:length() return self.bot - self.top end

---Compare two `Viewport`s.
---
---@param rhs Viewport `Viewport` to be compared with.
---@return Viewport[] deletions
---@return Viewport[] additions
function Viewport:diff(rhs)
  local deletions = {}
  local additions = {}

  if self.top < rhs.top then
    table.insert(deletions, Viewport.new(self.top, rhs.top))
  end
  if self.bot < rhs.bot then
    table.insert(additions, Viewport.new(self.bot, rhs.bot))
  end

  if self.top > rhs.top then
    table.insert(additions, Viewport.new(rhs.top, self.top))
  end
  if self.bot > rhs.bot then
    table.insert(deletions, Viewport.new(rhs.bot, self.bot))
  end

  return deletions, additions
end

---Split into multiple `Viewport`s.
---
---# Errors
---
---Throws if the `Viewport`'s length is not divisible by `n`.
---
---@param n integer How many `Viewport`s to be split into.
---@return Viewport[]
function Viewport:split(n)
  local length = self:length()
  assert(length % n == 0, "`Viewport`'s length must be divisible by `n`")

  local size = length / n
  local viewports = {}

  for i = 1, n do
    table.insert(viewports, Viewport.new(i * size, (i + 1) * size))
  end

  return viewports
end

---@param a Viewport
---@param b Viewport
---@return boolean
function metatable.__eq(a, b) return a.top == b.top and a.bot == b.bot end

return Viewport
