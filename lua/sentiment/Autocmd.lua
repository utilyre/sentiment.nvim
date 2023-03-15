---@class AutocmdArgs
---@field public id integer Autocmd ID.
---@field public group integer|nil Group ID.
---@field public event string Name of the triggered event.
---@field public match string Value that was matched against the pattern.
---@field public buf buffer Buffer being manipulated.
---@field public file string File name of the buffer being manipulated.
---@field public data any Passed arbitrary data.

---@class Autocmd
---@field private id integer|nil Autocmd ID.
---@field private name string Name used for creating its augroup.
---@field private desc string Documentation for troubleshooting.
---@field private events string[] Events that will trigger the handler.
---@field private callback fun(args: AutocmdArgs): boolean|nil Called when any of the events are triggered.
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

---Check whether the autocmd exists.
---
---@return boolean
function Autocmd:exists() return self.id ~= nil end

---Create the autocmd.
---
---NOTE: Will throw an error if this instance has already been created.
function Autocmd:create()
  if self.id ~= nil then error("autocmd has already been created", 2) end

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
  self.id = nil
end

return Autocmd
