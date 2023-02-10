local Pair = require("sentiment.pair")

local M = {}

function M.setup()
  vim.g.loaded_matchparen = 1

  local nsnr = vim.api.nvim_create_namespace("sentiment")

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = vim.api.nvim_create_augroup("sentiment", {}),
    callback = function(a)
      if vim.bo[a.buf].buftype ~= "" then return end

      local matchpairs = vim.opt.matchpairs:get()
      local lefts = {}
      local rights = {}
      for _, matchpair in ipairs(matchpairs) do
        local parts = vim.split(matchpair, ":", { plain = true })
        table.insert(lefts, parts[1])
        table.insert(rights, parts[2])
      end

      local winnr = vim.api.nvim_get_current_win()
      local cursor = vim.api.nvim_win_get_cursor(winnr)

      -- TODO: remaining_nests

      local line =
        vim.api.nvim_buf_get_lines(a.buf, cursor[1] - 1, cursor[1], true)[1]

      ---@type sentiment.Pair
      local pair
      for i = 1, #matchpairs do
        local left = lefts[i]
        local right = rights[i]

        local left_start, left_end = line:find(left, 1, true)
        local right_start, right_end = line:find(right, 1, true)

        if left_start ~= nil and right_start ~= nil then
          pair = Pair.new(
            { cursor[1] - 1, left_end - 1 },
            { cursor[1] - 1, right_end - 1 }
          )
          break
        end
      end

      vim.api.nvim_buf_clear_namespace(a.buf, nsnr, 0, -1)
      if pair ~= nil then pair:draw(a.buf, nsnr) end
    end,
  })
end

return M
