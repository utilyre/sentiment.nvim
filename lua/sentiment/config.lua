local default = require("sentiment.config.default")

local M = {}

local cfg = default

---Set config to a new value.
---
---@param c Config
function M.set(c) cfg = c end

---Check whether a buffer is included.
---
---@param buf buffer Buffer to be checked.
---@return boolean
function M.is_buffer_included(buf)
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype

  return cfg.included_buftypes[buftype] and not cfg.excluded_filetypes[filetype]
end

local left_matchpairs = {}
local right_matchpairs = {}
for _, matchpair in ipairs(cfg.matchpairs) do
  left_matchpairs[matchpair[1]] = true
  right_matchpairs[matchpair[2]] = true
end

---Check whether a character is a matchpair.
---
---@param char string Character to be checked.
---@param direction "left"|"right" Direction of the matchpair.
---@return boolean
function M.is_matchpair(char, direction)
  if direction == "left" then return left_matchpairs[char] end
  if direction == "right" then return right_matchpairs[char] end

  error(string.format("invalid direction: '%s'", direction), 2)
end

return M
