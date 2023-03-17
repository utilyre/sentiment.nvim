local config = require("sentiment.config")
local default = require("sentiment.config.default")

local M = {}

---Lint config and error if there are any problems.
---
---@param cfg Config Config to be linted.
local function lint(cfg)
  for _, pair in ipairs(cfg.pairs) do
    if pair[1] == pair[2] then
      error(
        string.format(
          "both sides of a pair can't have the same character: (%s, %s)",
          pair[1],
          pair[2]
        )
      )
    end
  end
end

---Override the default config.
---
---@param cfg Config Config to override.
function M.apply(cfg)
  cfg = vim.tbl_deep_extend("force", default, cfg)

  lint(cfg)
  config.set(cfg)
end

return M
