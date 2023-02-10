local M = {}

---Escape Lua pattern
---
---@param str string
---@return string
function M.escape_pattern(str)
  local escaped = str:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%1")
  return escaped
end

---Divide string into two halves at an index.
---
---@param str string
---@param mid number
function M.split_at(str, mid) return str:sub(0, mid), str:sub(mid) end

return M
