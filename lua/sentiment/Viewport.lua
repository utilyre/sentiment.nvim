---Visible area of buffer.
---
---@class Viewport
---@field public top integer Number of the very first visible line.
---@field public bot integer Number of the very last visible line.
local Viewport = {}

---Create a new instance of `Viewport`.
---
---@param top integer
---@param bot integer
---@return Viewport
function Viewport.new(top, bot)
  assert(top < bot, "`top` must be less than `bot`")

  local instance = setmetatable({}, { __index = Viewport })

  instance.top = top
  instance.bot = bot

  return instance
end

---Create a new instance of `Viewport` given a window.
---
---@param win window
---@return Viewport
function Viewport.with_win(win)
  local instance = setmetatable({}, { __index = Viewport })

  instance.top = vim.fn.line("w0", win)
  instance.bot = vim.fn.line("w$", win)

  return instance
end

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
---@param n integer How many `Viewport`s to be split into.
---@return Viewport[]
function Viewport:split(n)
  local size = (self.bot - self.top) / n
  local viewports = {}

  for i = 1, n do
    table.insert(viewports, Viewport.new(i * size, (i + 1) * size))
  end

  return viewports
end

return Viewport
