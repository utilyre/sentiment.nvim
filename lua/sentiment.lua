local manager = require("sentiment.config.manager")
local autocmds = require("sentiment.autocmds")
local ui = require("sentiment.ui")

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

  autocmds.renderer:create()
  create_user_commands()
end

---Disable the plugin.
function M.disable()
  if not autocmds.renderer:exists() then return end

  autocmds.renderer:remove()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    ui.clear(buf)
  end
end

---Re-enable the plugin.
function M.enable()
  if autocmds.renderer:exists() then return end

  autocmds.renderer:create()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    ui.render(win)
  end
end

return M
