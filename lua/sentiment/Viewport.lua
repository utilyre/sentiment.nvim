---Area of buffer.
---
---@class Viewport
---@field public top integer Index of the very first visible line.
---@field public bot integer Index of the very last visible line.
local Viewport = {}
local metatable = { __index = Viewport }

---Create a new instance of `Viewport`.
---
---# Errors
---
---Throws if `top` is greater than `bot`.
---
---@param top integer Index of the very first visible line.
---@param bot integer Index of the very last visible line.
---@return Viewport
function Viewport.new(top, bot)
  if top > bot then error("`top` must be less than `bot`", 2) end

  local instance = setmetatable({}, metatable)

  instance.top = top
  instance.bot = bot

  return instance
end

---Create a new instance of `Viewport` given a window.
---
---@param win window Window to take the visible area of.
---@return Viewport
function Viewport.from_win(win)
  return Viewport.new(vim.fn.line("w0", win), vim.fn.line("w$", win))
end

---Returns `Viewport`'s length.
---
---@return integer
function Viewport:length() return self.bot - self.top + 1 end

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

---Split into multiple parts.
---
---@param length integer Maximum length of each part.
---@return Viewport[]
function Viewport:split(length)
  local parts = {}

  for i = 1, math.ceil(self:length() / length) do
    table.insert(
      parts,
      Viewport.new(
        (i - 1) * length + self.top,
        math.min(i * length + self.top - 1, self.top + self:length() - 1)
      )
    )
  end

  return parts
end

---@param a Viewport
---@param b Viewport
---@return boolean
function metatable.__eq(a, b) return a.top == b.top and a.bot == b.bot end

return Viewport