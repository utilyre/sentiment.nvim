local ui = require("sentiment.ui")

local GROUP_UPDATER = "sentiment.updater"

local M = {}

function M.create_updater()
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = vim.api.nvim_create_augroup(GROUP_UPDATER, {}),
    callback = function() ui.update() end,
  })
end

return M
