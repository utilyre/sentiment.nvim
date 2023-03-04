local config = require("sentiment.config")
local default = require("sentiment.config.default")

local M = {}

---Override the default config.
---
---@param cfg Config Config to override.
function M.apply(cfg) config.set(vim.tbl_deep_extend("force", default, cfg)) end

return M
