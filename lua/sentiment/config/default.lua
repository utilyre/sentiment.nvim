---@class Config
local Config = {
  ---List of `(left, right)` match pair tuples.
  ---
  ---@type tuple<string, string>[]
  matchpairs = vim.tbl_map(
    function(matchpair) return vim.split(matchpair, ":", { plain = true }) end,
    vim.opt.matchpairs:get()
  ),
}

return Config
