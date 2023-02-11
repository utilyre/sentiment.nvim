local utils = require("sentiment.utils")
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

      local current_line =
        vim.api.nvim_buf_get_lines(a.buf, cursor[1] - 1, cursor[1], false)[1]

      local left_half, right_half = utils.split_at(current_line, cursor[2] + 1)
      -- TODO: fetch visible lines and lookup pairs in there

      -- BUG: highlighting breaks when cursor is ON a matchpair
      -- Like () or ( { "Hi" }, "Hello" }
      local left_pos, right_pos

      local remaining_nests = 0
      for i = #left_half, 1, -1 do
        local ch = left_half:sub(i, i)

        if vim.tbl_contains(rights, ch) then
          remaining_nests = remaining_nests + 1
          goto continue
        end

        if vim.tbl_contains(lefts, ch) then
          if remaining_nests > 0 then
            remaining_nests = remaining_nests - 1
            goto continue
          end

          left_pos = i
          break
        end

        ::continue::
      end
      --[[ local ]] remaining_nests = 0
      for i = 1, #right_half, 1 do
        local ch = right_half:sub(i, i)

        if vim.tbl_contains(lefts, ch) then
          remaining_nests = remaining_nests + 1
          goto continue
        end

        if vim.tbl_contains(rights, ch) then
          if remaining_nests > 0 then
            remaining_nests = remaining_nests - 1
            goto continue
          end

          right_pos = (#left_half - 1) + i
          break
        end

        ::continue::
      end

      vim.api.nvim_buf_clear_namespace(a.buf, nsnr, 0, -1)
      if left_pos ~= nil and right_pos ~= nil then
        local pair = Pair.new(
          { cursor[1] - 1, left_pos - 1 },
          { cursor[1] - 1, right_pos - 1 }
        )

        if pair ~= nil then pair:draw(a.buf, nsnr) end
      end
    end,
  })
end

return M
