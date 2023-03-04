local config = require("sentiment.config")
local manager = require("sentiment.config.manager")

local M = {}

---Load and setup the plugin with an optional config table.
---
---NOTE: Calling this disables the builtin matchparen plugin.
---
---@param cfg? Config User config to be applied.
function M.setup(cfg)
  vim.g.loaded_matchparen = 1
  manager.apply(cfg or {})

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = vim.api.nvim_create_augroup("sentiment", {}),
    callback = function(args)
      if not config.is_buffer_included(args.buf) then return end

      print("Hello world!")
    end,
  })
end

return M
