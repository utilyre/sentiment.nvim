local ui = require("sentiment.ui")

local GROUP_RENDERER = "sentiment.renderer"

local M = {}

---Render pairs on necessary events.
function M.create_renderer()
  vim.api.nvim_create_autocmd({
    "WinScrolled",
    "CursorMoved",
    "CursorMovedI",
  }, {
    group = vim.api.nvim_create_augroup(GROUP_RENDERER, {}),
    callback = function() ui.render() end,
  })
end

return M
