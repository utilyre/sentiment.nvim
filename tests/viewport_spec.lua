local Viewport = require("sentiment.Viewport")

local function should_fail(fn, message)
  local ok = pcall(fn)
  assert(not ok, message)
end

describe("`new`", function()
  it("does not accept `top` to be greater than `bot`", function()
    should_fail(function() Viewport.new(10, 5) end)
  end)
end)
