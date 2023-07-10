---Area of buffer.
---
---@class Region
---@field public top integer Index of the very first visible line.
---@field public bot integer Index of the very last visible line.
local Region = {}
local metatable = { __index = Region }

---Create a new instance of `Region`.
---
---# Errors
---
---Throws if `top` is greater than `bot`.
---
---@param top integer Index of the very first visible line.
---@param bot integer Index of the very last visible line.
---@return Region
function Region.new(top, bot)
  if top > bot then error("`top` must be less than `bot`", 2) end

  local instance = setmetatable({}, metatable)

  instance.top = top
  instance.bot = bot

  return instance
end

---Create a new instance of `Region` given a window.
---
---@param win window Window to take the visible area of.
---@return Region
function Region.from_win(win)
  return Region.new(vim.fn.line("w0", win), vim.fn.line("w$", win))
end

---Return length.
---
---@return integer
function Region:length() return self.bot - self.top + 1 end

---Compare two `Region`s.
---
---@param rhs Region `Region` to be compared with.
---@return Region[] deletions
---@return Region[] additions
function Region:diff(rhs)
  local deletions = {}
  local additions = {}

  if self.top < rhs.top then
    table.insert(deletions, Region.new(self.top, rhs.top))
  end
  if self.bot < rhs.bot then
    table.insert(additions, Region.new(self.bot, rhs.bot))
  end

  if self.top > rhs.top then
    table.insert(additions, Region.new(rhs.top, self.top))
  end
  if self.bot > rhs.bot then
    table.insert(deletions, Region.new(rhs.bot, self.bot))
  end

  return deletions, additions
end

---Split into multiple parts.
---
---@param length integer Maximum length of each part.
---@return Region[]
function Region:split(length)
  local parts = {}

  for i = 1, math.ceil(self:length() / length) do
    table.insert(
      parts,
      Region.new(
        (i - 1) * length + self.top,
        math.min(i * length + self.top - 1, self.top + self:length() - 1)
      )
    )
  end

  return parts
end

---@param a Region
---@param b Region
---@return boolean
function metatable.__eq(a, b) return a.top == b.top and a.bot == b.bot end

return Region
