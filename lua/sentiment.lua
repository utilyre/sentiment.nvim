local manager = require("sentiment.config.manager")
local autocmds = require("sentiment.autocmds")

local M = {}

---Create `matchparen.vim` style user commands.
local function create_user_commands()
  vim.api.nvim_create_user_command("NoMatchParen", function() M.disable() end, {
    desc = "Disable the plugin",
  })

  vim.api.nvim_create_user_command("DoMatchParen", function() M.enable() end, {
    desc = "Re-enable the plugin",
  })
end

---Load and setup the plugin with an optional `Config`.
---
---NOTE: Calling this disables the builtin `matchparen.vim` plugin.
---
---@param cfg? Config User `Config` to be applied.
function M.setup(cfg)
  vim.g.loaded_matchparen = 1
  manager.apply(cfg or {})

  autocmds.start_rendering()
  autocmds.create_cleaner()
  create_user_commands()
end

---Disable the plugin.
function M.disable() autocmds.stop_rendering() end

---Re-enable the plugin.
function M.enable() autocmds.start_rendering() end

return M
