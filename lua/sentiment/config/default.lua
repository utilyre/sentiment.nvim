---@class Config
local Config = {
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
