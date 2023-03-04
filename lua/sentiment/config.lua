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

return M
