local manager = require("sentiment.config.manager")
local autocmds = require("sentiment.autocmds")
local ui = require("sentiment.ui")

local M = {}

---Create matchparen.vim style user commands.
local function create_user_commands()
  vim.api.nvim_create_user_command("NoMatchParen", function()
    if not autocmds.renderer:exists() then return end

    autocmds.renderer:remove()
    ui.clear()
  end, {})

  vim.api.nvim_create_user_command("DoMatchParen", function()
    if autocmds.renderer:exists() then return end

    ui.render()
    autocmds.renderer:create()
  end, {})
end

---Load and setup the plugin with an optional config table.
---
---NOTE: Calling this disables the builtin matchparen plugin.
---
---@param cfg? Config User config to be applied.
function M.setup(cfg)
  vim.g.loaded_matchparen = 1
  manager.apply(cfg or {})

  autocmds.renderer:create()
  create_user_commands()
end

return M
