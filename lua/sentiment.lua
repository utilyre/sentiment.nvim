local M = {}

function M.setup()
  vim.g.loaded_matchparen = 1

  local nsnr = vim.api.nvim_create_namespace("sentiment")

  -- vim.api.nvim_buf_add_highlight(bufnr, ns, "MatchParen", 3, 1, -1)
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

      local opening_position
      local closing_position
      for i = 1, #openings do
        local opening = openings[i]
        local closing = closings[i]

        local opening_start, opening_end = line:find(opening, 1, true)
        local closing_start, closing_end = line:find(closing, 1, true)

        if opening_start ~= nil then
          opening_position = { opening_start, opening_end }
        end
        if closing_start ~= nil then
          closing_position = { closing_start, closing_end }
        end
        if opening_start ~= nil or closing_start ~= nil then break end
      end

      vim.api.nvim_buf_clear_namespace(a.buf, nsnr, 0, -1)
      if opening_position ~= nil then
        vim.api.nvim_buf_add_highlight(
          a.buf,
          nsnr,
          "MatchParen",
          cursor[1] - 1,
          opening_position[1] - 1,
          opening_position[2]
        )
      end
      if closing_position ~= nil then
        vim.api.nvim_buf_add_highlight(
          a.buf,
          nsnr,
          "MatchParen",
          cursor[1] - 1,
          closing_position[1] - 1,
          closing_position[2]
        )
      end
    end,
  })
end

return M
