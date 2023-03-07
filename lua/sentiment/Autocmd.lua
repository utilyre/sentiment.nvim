---@class Autocmd
---@field private id integer|nil Autocmd ID.
---@field public name string Name used for creating its augroup.
---@field public desc string Documentation for troubleshooting.
---@field public events string[] Events that will trigger the handler.
---@field public callback fun(args: AutocmdArgs): boolean|nil Called when any of the events are triggered.
local Autocmd = {}

---Create a new instance of Autocmd.
---
---@param name string Name used for creating its augroup.
---@param desc string Documentation for troubleshooting.
---@param events string[] Events that will trigger the handler.
---@param callback fun(args: AutocmdArgs): boolean|nil Called when any of the events are triggered.
---@return Autocmd
function Autocmd.new(name, desc, events, callback)
  local instance = setmetatable({}, { __index = Autocmd })

  instance.name = name
  instance.desc = desc
  instance.events = events
  instance.callback = callback

  return instance
end

---Create the autocmd.
function Autocmd:create()
  local group =
    vim.api.nvim_create_augroup(string.format("sentiment.%s", self.name), {})

  self.id = vim.api.nvim_create_autocmd(self.events, {
    desc = self.desc,
    group = group,
    callback = self.callback,
  })
end

---Remove the autocmd.
---
---NOTE: Will throw an error if this instance hasn't been created yet.
function Autocmd:remove()
  if self.id == nil then error("autocmd hasn't been created yet", 2) end
  vim.api.nvim_del_autocmd(self.id)
end

return Autocmd
