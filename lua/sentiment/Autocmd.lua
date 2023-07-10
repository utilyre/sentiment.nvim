---@class AutocmdArgs
---@field public id integer Autocmd ID.
---@field public group integer|nil Group ID.
---@field public event string Name of the triggered event.
---@field public match string Value that was matched against the pattern.
---@field public buf buffer Buffer being manipulated.
---@field public file string File name of the buffer being manipulated.
---@field public data any Passed arbitrary data.

---@class AutocmdSpec
---@field public name string Name used for creating its augroup.
---@field public desc string Documentation for troubleshooting.
---@field public events string[] Events that will trigger the handler.
---@field public callback fun(args: AutocmdArgs): boolean|nil Called when any of the events are triggered.

---Strictly typed helper for `nvim_create_autocmd` and `nvim_del_autocmd` APIs.
---
---# Examples
---
---```lua
---local Autocmd = require("sentiment.Autocmd")
---
-----instantiate it
---local my_autocmd = Autocmd.new({
---  name = "my_autocmd",
---  desc = "This is my autocmd",
---  events = { "BufEnter" },
---  callback = function(args)
---    print(args.buf)
---  end,
---})
---
----- create it
---my_autocmd:create()
---
----- later on, remove it if needed
---if my_autocmd:exists() then
---  my_autocmd:remove()
---end
---```
---
---@class Autocmd
---@field private id integer|nil Autocmd ID.
---@field private name string Name used for creating its augroup.
---@field private desc string Documentation for troubleshooting.
---@field private events string[] Events that will trigger the handler.
---@field private callback fun(args: AutocmdArgs): boolean|nil Called when any of the events are triggered.
local Autocmd = {}
local metatable = { __index = Autocmd }

---Create a new instance of Autocmd.
---
---@nodiscard
---@param spec AutocmdSpec Autocmd specification.
---@return Autocmd
function Autocmd.new(spec)
  local instance = setmetatable({}, metatable)

  instance.name = spec.name
  instance.desc = spec.desc
  instance.events = spec.events
  instance.callback = spec.callback

  return instance
end

---Check whether the autocmd exists.
---
---@return boolean
function Autocmd:exists() return self.id ~= nil end

---Create the autocmd.
---
---@return boolean success
function Autocmd:create()
  if self:exists() then return false end

  local group =
    vim.api.nvim_create_augroup(string.format("sentiment.%s", self.name), {})

  self.id = vim.api.nvim_create_autocmd(self.events, {
    desc = self.desc,
    group = group,
    callback = self.callback,
  })

  return true
end

---Remove the autocmd.
---
---@return boolean success
function Autocmd:remove()
  if not self:exists() then return false end

  vim.api.nvim_del_autocmd(self.id)
  self.id = nil

  return true
end

return Autocmd
