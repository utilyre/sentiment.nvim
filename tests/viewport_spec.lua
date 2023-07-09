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

      assert.is.equal(2, deletions[1].top)
      assert.is.equal(5, deletions[1].bot)

      assert.is.equal(7, additions[1].top)
      assert.is.equal(10, additions[1].bot)
    end)

    it("`vp1` is slightly ahead `vp2`", function()
      local vp1 = Viewport.new(5, 10)
      local vp2 = Viewport.new(2, 7)

      local deletions, additions = vp1:diff(vp2)

      assert.is.equal(7, deletions[1].top)
      assert.is.equal(10, deletions[1].bot)

      assert.is.equal(2, additions[1].top)
      assert.is.equal(5, additions[1].bot)
    end)

    it("`vp1` contains `vp2`", function()
      local vp1 = Viewport.new(2, 10)
      local vp2 = Viewport.new(5, 7)

      local deletions, additions = vp1:diff(vp2)

      assert.is.equal(2, deletions[1].top)
      assert.is.equal(5, deletions[1].bot)
      assert.is.equal(7, deletions[2].top)
      assert.is.equal(10, deletions[2].bot)

      assert.is.equal(0, #additions)
    end)

    it("`vp1` is contained by `vp2`", function()
      local vp1 = Viewport.new(5, 7)
      local vp2 = Viewport.new(2, 10)

      local deletions, additions = vp1:diff(vp2)

      assert.is.equal(0, #deletions)

      assert.is.equal(7, additions[1].top)
      assert.is.equal(10, additions[1].bot)
      assert.is.equal(2, additions[2].top)
      assert.is.equal(5, additions[2].bot)
    end)
  end)
end)

describe("`split`", function()
  it(
    "correctly outputs when the `Viewport`'s length is divisible by the given `n`",
    function()
      local vp = Viewport.new(2, 10)
      local parts = vp:split(4)

      assert.is.equal(2, parts[1].top)
      assert.is.equal(4, parts[1].bot)

      assert.is.equal(4, parts[2].top)
      assert.is.equal(6, parts[2].bot)

      assert.is.equal(6, parts[3].top)
      assert.is.equal(8, parts[3].bot)

      assert.is.equal(8, parts[4].top)
      assert.is.equal(10, parts[4].bot)
    end
  )

  it(
    "does not accept `Viewport`'s length not to be divisible by the given `n`",
    function()
      should_fail(function()
        local vp = Viewport.new(2, 10)
        vp:split(5)
      end)
    end
  )
end)
