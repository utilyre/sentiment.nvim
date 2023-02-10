local Pair = require("sentiment.pair")

local M = {}

function M.setup()
  vim.g.loaded_matchparen = 1

  local nsnr = vim.api.nvim_create_namespace("sentiment")

  vim.api.nvim_create_autocmd({
    "CursorMoved",
    "CursorMovedI",
  }, {
    group = vim.api.nvim_create_augroup("sentiment", {}),
    callback = function(a)
      local matchpairs = vim.opt.matchpairs:get()
      local openings = {}
      local closings = {}
      for _, matchpair in ipairs(matchpairs) do
        local parts = vim.split(matchpair, ":", { plain = true })
        table.insert(openings, parts[1])
        table.insert(closings, parts[2])
      end

      local winnr = vim.api.nvim_get_current_win()
      local cursor = vim.api.nvim_win_get_cursor(winnr)

      -- TODO: remaining_nests

      local line =
        vim.api.nvim_buf_get_lines(a.buf, cursor[1] - 1, cursor[1], true)[1]

      ---@type sentiment.Pair
      local pair
      for i = 1, #matchpairs do
        local opening = openings[i]
        local closing = closings[i]

        local opening_start, opening_end = line:find(opening, 1, true)
        local closing_start, closing_end = line:find(closing, 1, true)

        if opening_start ~= nil and closing_start ~= nil then
          pair = Pair.new(
            { cursor[1] - 1, opening_end - 1 },
            { cursor[1] - 1, closing_end - 1 }
          )
          break
        end
      end

      vim.api.nvim_buf_clear_namespace(a.buf, nsnr, 0, -1)
      if pair ~= nil then pair:draw(nsnr, a.buf) end
    end,
  })
end

return M
