local utils = require("sentiment.utils")
local Pair = require("sentiment.pair")

local M = {}

local function find_right(lefts, rights, top, bot, lines, row, col)
  local start = col

  local remaining = 0
  for i = row, bot, 1 do
    local line = lines[i]
    if i == row + 1 then start = 1 end

    for j = start, #line, 1 do
      local char = line:sub(j, j)

      if lefts[char] then
        remaining = remaining + 1
      elseif rights[char] then
        if remaining == 0 then return { top + i - 1, j } end
        remaining = remaining - 1
      end
    end
  end
end

function M.setup()
  vim.g.loaded_matchparen = 1

  local ns = vim.api.nvim_create_namespace("sentiment")
  local matchpairs = vim.opt.matchpairs:get()
  local lefts = {}
  local rights = {}
  for _, matchpair in ipairs(matchpairs) do
    local parts = vim.split(matchpair, ":", { plain = true })
    lefts[parts[1]] = true
    rights[parts[2]] = true
  end

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = vim.api.nvim_create_augroup("sentiment", {}),
    callback = function(args)
      args.win = vim.api.nvim_get_current_win()
      if vim.bo[args.buf].buftype ~= "" then return end

      local top = vim.fn.line("w0", args.win)
      local bot = vim.fn.line("w$", args.win)

      local lines = vim.api.nvim_buf_get_lines(args.buf, top - 1, bot, true)
      local row, col = unpack(vim.api.nvim_win_get_cursor(args.win))
      col = col + 1

      local left = nil
      -- ...
      left = { 1, 1 }

      local right = find_right(lefts, rights, top, bot, lines, row, col)

      vim.api.nvim_buf_clear_namespace(args.buf, ns, 0, -1)
      if left == nil or right == nil then return end

      local pair = Pair.new({ 1, 1 }, right)
      pair:draw(args.buf, ns)
    end,
  })
end

return M
