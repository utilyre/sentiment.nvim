local Region = require("sentiment.Region")

describe("`.new()`", function()
  it("does not accept `top` to be greater than `bot`", function()
    assert.has.error(function() Region.new(10, 5) end)
  end)
end)

describe("`:diff()`", function()
  it("works when `a` is slightly behind `b`", function()
    local a = Region.new(2, 7)
    local b = Region.new(5, 10)
    local deletions, additions = a:diff(b)

    assert.is.equal(Region.new(2, 5), deletions[1])
    assert.is.equal(Region.new(7, 10), additions[1])
  end)

  it("works when `a` is slightly ahead `b`", function()
    local a = Region.new(5, 10)
    local b = Region.new(2, 7)
    local deletions, additions = a:diff(b)

    assert.is.equal(Region.new(7, 10), deletions[1])
    assert.is.equal(Region.new(2, 5), additions[1])
  end)

  it("works when `a` contains `b`", function()
    local a = Region.new(2, 10)
    local b = Region.new(5, 7)
    local deletions, additions = a:diff(b)

    assert.is.equal(Region.new(2, 5), deletions[1])
    assert.is.equal(Region.new(7, 10), deletions[2])
    assert.is.equal(0, #additions)
  end)

  it("works when `a` is contained by `b`", function()
    local a = Region.new(5, 7)
    local b = Region.new(2, 10)
    local deletions, additions = a:diff(b)

    assert.is.equal(0, #deletions)
    assert.is.equal(Region.new(7, 10), additions[1])
    assert.is.equal(Region.new(2, 5), additions[2])
  end)
end)

describe("`:split()`", function()
  it("works when length is divisible by the given `n`", function()
    local a = Region.new(3, 10)
    local parts = a:split(2)

    assert.is.equal(Region.new(3, 4), parts[1])
    assert.is.equal(Region.new(5, 6), parts[2])
    assert.is.equal(Region.new(7, 8), parts[3])
    assert.is.equal(Region.new(9, 10), parts[4])
  end)

  it(
    "works when length is not divisible by the given `n`",
    function()
      local a = Region.new(2, 20)
      local parts = a:split(5)

      assert.is.equal(Region.new(2, 6), parts[1])
      assert.is.equal(Region.new(7, 11), parts[2])
      assert.is.equal(Region.new(12, 16), parts[3])
      assert.is.equal(Region.new(17, 20), parts[4])
    end
  )
end)
