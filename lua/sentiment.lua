local manager = require("sentiment.config.manager")
local autocmds = require("sentiment.autocmds")

local M = {}

---Load and setup the plugin with an optional config table.
---
---NOTE: Calling this disables the builtin matchparen plugin.
---
---@param cfg? Config User config to be applied.
function M.setup(cfg)
  vim.g.loaded_matchparen = 1
  manager.apply(cfg or {})

  autocmds.renderer:create()
end

return M
