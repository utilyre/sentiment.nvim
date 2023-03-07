---@meta

---@alias tuple<P, S> { [1]: P, [2]: S }

---@alias window integer
---@alias buffer integer
---@alias namespace integer

---@class AutocmdArgs
---@field public id integer Autocmd ID.
---@field public group integer|nil Group ID.
---@field public event string Name of the triggered event.
---@field public match string Value that was matched against the pattern.
---@field public buf buffer Buffer being manipulated.
---@field public file string File name of the buffer being manipulated.
---@field public data any Passed arbitrary data.
