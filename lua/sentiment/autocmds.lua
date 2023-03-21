local Autocmd = require("sentiment.Autocmd")
local ui = require("sentiment.ui")

local M = {}

---`Pair` renderer.
M.renderer = Autocmd.new({
  name = "renderer",
  desc = "Render pair",
  events = {
    "BufReadPre",
    "WinScrolled",
    "ModeChanged",
    "CursorMoved",
    "CursorMovedI",
  },
  callback = function() ui.render() end,
})

return M
