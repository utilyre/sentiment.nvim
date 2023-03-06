local default = require("sentiment.config.default")

local M = {}

local cfg = default

---Set config to a new value.
---
---@param c Config
function M.set(c) cfg = c end

---Check whether to create an updater autocmd.
---
---@return boolean
function M.can_create_updater()
  return cfg.create_updater_autocmd
end

---Check whether a buffer is included.
---
---@param buf buffer Buffer to be checked.
---@return boolean
function M.is_buffer_included(buf)
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype

  return cfg.included_buftypes[buftype] and not cfg.excluded_filetypes[filetype]
end

---Get how many lines to look backwards/forwards to find a pair.
---
---@return integer
function M.get_limit()
  return cfg.limit
end

local left_pairs = {}
local right_pairs = {}
for _, matchpair in ipairs(cfg.matchpairs) do
  left_pairs[matchpair[1]] = true
  right_pairs[matchpair[2]] = true
end

---Check whether a character is a pair.
---
---@param left boolean Whether it should be a left pair.
---@param char string Character to be checked.
---@return boolean
function M.is_matchpair(left, char)
  if left then
    return left_pairs[char]
  end

  return right_pairs[char]
end

return M
