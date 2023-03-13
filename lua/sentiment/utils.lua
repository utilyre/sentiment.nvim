local M = {}

---If `cond` is true, return `t` otherwise `f`.
---
---NOTE: One drawback is that both expression will be executed at runtime.
---
---@generic T, F
---@param cond boolean Condition expression.
---@param t T Consequent expression.
---@param f F Alternative expression.
---@return T|F
function M.ternary(cond, t, f)
  if cond then
    return t
  else
    return f
  end
end

return M
