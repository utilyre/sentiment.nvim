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

---Check whether a character is a matchpair.
---
---@param char string Character to be checked.
---@param direction "left"|"right" Direction of the matchpair.
---@return integer|nil
function M.is_matchpair(char, direction)
  for i, matchpair in ipairs(cfg.matchpairs) do
    if direction == "left" and matchpair[1] == char then return i end
    if direction == "right" and matchpair[2] == char then return i end
  end

  return nil
end

return M
