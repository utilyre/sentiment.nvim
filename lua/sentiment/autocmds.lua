local Autocmd = require("sentiment.Autocmd")
local ui = require("sentiment.ui")

local M = {}

local timer = nil

---Close `timer` safely.
local function close_timer()
  if timer == nil or not timer:is_active() then return end
  timer:close()
end

local renderer = Autocmd.new({
  name = "renderer",
  desc = "Render pair",
  events = {
    "BufWinEnter",
    "WinScrolled",
    "ModeChanged",
    "CursorMoved",
    "CursorMovedI",
  },
  callback = function()
    close_timer()
    timer = ui.render()
  end,
})

---Start rendering pairs.
function M.start_rendering()
  if renderer:exists() then return end

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    timer = ui.render(win)
  end

  renderer:create()
end

---Stop rendering pairs.
function M.stop_rendering()
  if not renderer:exists() then return end

  renderer:remove()
  close_timer()

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    ui.clear(buf)
  end
end

return M
