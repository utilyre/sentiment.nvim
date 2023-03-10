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

---Get how many lines to look backwards/forwards to find a pair.
---
---@return integer
function M.get_limit() return cfg.limit end

local left_to_right = {}
local right_to_left = {}
for _, pair in ipairs(cfg.pairs) do
  left_to_right[pair[1]] = pair[2]
  right_to_left[pair[2]] = pair[1]
end

---Get the corresponding right pair of a left pair
---
---@param left string
---@return string
function M.get_right_by_left(left) return left_to_right[left] end

---Get the corresponding left pair of a right pair
---
---@param right string
---@return string
function M.get_left_by_right(right) return right_to_left[right] end

return M
