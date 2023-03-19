local config = require("sentiment.config")
local default = require("sentiment.config.default")

local M = {}

---Lint `Config` and error if there are any problems.
---
---@param cfg Config Config to be linted.
local function lint(cfg)
  for _, pair in ipairs(cfg.pairs) do
    if pair[1] == pair[2] then
      error(
        string.format(
          "`pairs`: both sides of a pair can't have the same character",
          pair[1],
          pair[2]
        ),
        4
      )
    end
  end
end

---Override the default `Config`.
---
---@param cfg Config `Config` to override with.
function M.apply(cfg)
  cfg = vim.tbl_deep_extend("force", default, cfg)

  lint(cfg)
  config.set(cfg)
end

return M
