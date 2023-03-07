local Autocmd = require("sentiment.Autocmd")
local manager = require("sentiment.config.manager")
local ui = require("sentiment.ui")

local M = {}

---Load and setup the plugin with an optional config table.
---
---NOTE: Calling this disables the builtin matchparen plugin.
---
---@param cfg? Config User config to be applied.
function M.setup(cfg)
  vim.g.loaded_matchparen = 1
  manager.apply(cfg or {})

  local renderer = Autocmd.new(
    "renderer",
    "Render pairs",
    { "WinScrolled", "CursorMoved", "CursorMovedI" },
    function() ui.render() end
  )

  renderer:create()
end

return M
