local Autocmd = require("sentiment.Autocmd")
local ui = require("sentiment.ui")

local M = {}

---Pair renderer.
M.renderer = Autocmd.new(
  "renderer",
  "Render pairs",
  { "WinScrolled", "CursorMoved", "CursorMovedI" },
  function() ui.render() end
)

return M
