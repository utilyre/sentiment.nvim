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

  ---How much (in milliseconds) should the cursor stay still to calculate and
  ---render a pair.
  ---
  ---NOTE: It's recommended to set this somewhere above and close to your key
  ---repeat speed in order to keep the calculations at minimum.
  ---
  ---@type integer
  delay = 50,

  ---How many lines to look backwards/forwards to find a pair.
  ---
  ---@type integer
  limit = 100,

  ---List of `(left, right)` pairs.
  ---
  ---@type tuple<string, string>[]
  pairs = {
    { "(", ")" },
    { "{", "}" },
    { "[", "]" },
  },
}

return Config
