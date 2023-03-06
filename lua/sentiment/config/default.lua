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

  ---How many lines to look backwards/forwards to find a pair.
  ---
  ---@type integer
  limit = 100,

  ---List of left side pairs.
  ---
  ---@type table<string, boolean>
  lefts = {
    ["("] = true,
    ["{"] = true,
    ["["] = true,
  },

  ---List of right side pairs.
  ---
  ---@type table<string, boolean>
  rights = {
    [")"] = true,
    ["}"] = true,
    ["]"] = true,
  },
}

return Config
