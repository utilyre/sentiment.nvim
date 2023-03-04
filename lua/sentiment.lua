local config = require("sentiment.config")
local manager = require("sentiment.config.manager")
local Portion = require("sentiment.portion")
local Pair = require("sentiment.pair")

local M = {}

local function find_right(portion)
  local remaining = 0
  for cursor, char in portion:iter(false) do
    if config.is_matchpair(char, "left") then
      remaining = remaining + 1
    elseif config.is_matchpair(char, "right") then
      if remaining == 0 then return cursor end
      remaining = remaining - 1
    end
  end
end

local function find_left(portion)
  local remaining = 0
  for cursor, char in portion:iter(true) do
    if config.is_matchpair(char, "right") then
      remaining = remaining + 1
    elseif config.is_matchpair(char, "left") then
      if remaining == 0 then return cursor end
      remaining = remaining - 1
    end
  end
end

---Load and setup the plugin with an optional config table.
---
---NOTE: Calling this disables the builtin matchparen plugin.
---
---@param cfg? Config User config to be applied.
function M.setup(cfg)
  vim.g.loaded_matchparen = 1
  manager.apply(cfg or {})

  local ns = vim.api.nvim_create_namespace("sentiment")

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = vim.api.nvim_create_augroup("sentiment", {}),
    callback = function(args)
      if not config.is_buffer_included(args.buf) then return end

      local portion = Portion.new(0)
      local under_cursor = portion:get_current_char()

      local left = nil
      local right = nil

      if config.is_matchpair(under_cursor, "left") then
        left = portion.cursor
        right = find_right(portion)
      elseif config.is_matchpair(under_cursor, "right") then
        right = portion.cursor
        left = find_left(portion)
      else
        left = find_left(portion)
        right = find_right(portion)
      end

      vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
      if left ~= nil and right ~= nil then
        local pair = Pair.new(left, right)
        pair:draw(args.buf, ns)
      end
    end,
  })
end

return M
