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

  ---Dictionary to check whether a mode should be included.
  ---
  ---@type table<string, boolean>
  included_modes = {
    n = true,
    i = true,
  },

  ---List of `(left, right)` pairs.
  ---
  ---NOTE: Both sides of a pair can't have the same character.
  ---
  ---@type tuple<string, string>[]
  pairs = {
    { "(", ")" },
    { "{", "}" },
    { "[", "]" },
  },
}

return Config
