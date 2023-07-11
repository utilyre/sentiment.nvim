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
