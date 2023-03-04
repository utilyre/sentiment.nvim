local GROUP_UPDATER = "sentiment.updater"

local M = {}

function M.create_updater(events, callback)
  vim.api.nvim_create_autocmd(events, {
    group = vim.api.nvim_create_augroup(GROUP_UPDATER, {}),
    callback = callback,
  })
end

return M
