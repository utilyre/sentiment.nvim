local default = require("sentiment.config.default")

local M = {}

---User config.
---
---@type Config
M.user = {}

---Extends user config with the default config.
---
---@param config Config User config to be extended.
function M.apply(config) M.user = vim.tbl_deep_extend("force", default, config) end

return M
