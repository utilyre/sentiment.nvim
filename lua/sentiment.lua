local M = {}

function M.setup()
  vim.g.loaded_matchparen = 1

  local nsnr = vim.api.nvim_create_namespace("sentiment")

  -- vim.api.nvim_buf_add_highlight(bufnr, ns, "MatchParen", 3, 1, -1)
  vim.api.nvim_create_autocmd("CursorHold", {
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
      local pos
      for _, opening in ipairs(openings) do
        local start, endi = line:find(opening, 1, true)

        if start ~= nil then
          pos = { start, endi }
          break
        end
      end

      vim.api.nvim_buf_clear_namespace(a.buf, nsnr, 0, -1)
      if pos ~= nil then
        vim.api.nvim_buf_add_highlight(
          a.buf,
          nsnr,
          "MatchParen",
          cursor[1] - 1,
          pos[1] - 1,
          pos[2]
        )
      end
    end,
  })
end

return M
