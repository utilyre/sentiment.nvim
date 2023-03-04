---@class Config
local Config = {
  ---Whether to create an updater autocmd.
  ---
  ---If you wish to create your own, here's the recipe:
  ---
  ---```lua
  ---vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  ---  group = vim.api.nvim_create_augroup("sentiment.my_updater", {}),
  ---  callback = function() require("sentiment.ui").update() end,
  ---})
  ---```
  ---
  ---@type boolean
  create_updater_autocmd = true,

  ---Dictionary to check whether a buftype should be included.
  ---
  ---@type table<string, boolean>
  included_buftypes = {
    [""] = true,
  },

  ---Dictionary to check whether a filetype should be excluded.
  ---
  ---@type table<string, boolean>
  excluded_filetypes = {},

  ---List of `(left, right)` match pair tuples.
  ---
  ---@type tuple<string, string>[]
  matchpairs = vim.tbl_map(
    function(matchpair) return vim.split(matchpair, ":", { plain = true }) end,
    vim.opt.matchpairs:get()
  ),
}

return Config
