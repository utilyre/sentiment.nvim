local Viewport = require("sentiment.Viewport")

local function should_fail(fn)
  local ok = pcall(fn)
  assert(not ok, "should have failed")
end

describe("`new`", function()
  it("does not accept `top` to be greater than `bot`", function()
    should_fail(function() Viewport.new(10, 5) end)
  end)
end)

describe("`diff`", function()
  describe("correctly outputs when", function()
    it("`vp1` is slightly behind `vp2`", function()
      local vp1 = Viewport.new(2, 7)
      local vp2 = Viewport.new(5, 10)
      local deletions, additions = vp1:diff(vp2)

      assert.is.equal(Viewport.new(2, 5), deletions[1])
      assert.is.equal(Viewport.new(7, 10), additions[1])
    end)

    it("`vp1` is slightly ahead `vp2`", function()
      local vp1 = Viewport.new(5, 10)
      local vp2 = Viewport.new(2, 7)
      local deletions, additions = vp1:diff(vp2)

      assert.is.equal(Viewport.new(7, 10), deletions[1])
      assert.is.equal(Viewport.new(2, 5), additions[1])
    end)

    it("`vp1` contains `vp2`", function()
      local vp1 = Viewport.new(2, 10)
      local vp2 = Viewport.new(5, 7)
      local deletions, additions = vp1:diff(vp2)

      assert.is.equal(Viewport.new(2, 5), deletions[1])
      assert.is.equal(Viewport.new(7, 10), deletions[2])
      assert.is.equal(0, #additions)
    end)

    it("`vp1` is contained by `vp2`", function()
      local vp1 = Viewport.new(5, 7)
      local vp2 = Viewport.new(2, 10)
      local deletions, additions = vp1:diff(vp2)

      assert.is.equal(0, #deletions)
      assert.is.equal(Viewport.new(7, 10), additions[1])
      assert.is.equal(Viewport.new(2, 5), additions[2])
    end)
  end)
end)

describe("`split`", function()
  describe("correctly outputs when", function()
    it("`Viewport`'s length is divisible by the given `n`", function()
      local vp = Viewport.new(3, 10)
      local parts = vp:split(2)

      assert.is.equal(Viewport.new(3, 4), parts[1])
      assert.is.equal(Viewport.new(5, 6), parts[2])
      assert.is.equal(Viewport.new(7, 8), parts[3])
      assert.is.equal(Viewport.new(9, 10), parts[4])
    end)

    it("`Viewport`'s length is not divisible by the given `n`", function()
      local vp = Viewport.new(2, 20)
      local parts = vp:split(5)

      assert.is.equal(Viewport.new(2, 6), parts[1])
      assert.is.equal(Viewport.new(7, 11), parts[2])
      assert.is.equal(Viewport.new(12, 16), parts[3])
      assert.is.equal(Viewport.new(17, 20), parts[4])
    end)
  end)
end)
