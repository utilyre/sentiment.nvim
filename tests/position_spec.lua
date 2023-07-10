local Position = require("sentiment.Position")

describe("`<`", function()
  it("works with different lines", function()
    local a = Position.new(2, 8)
    local b = Position.new(3, 7)
    local c = Position.new(7, 1)
    local d = Position.new(5, 8)

    assert.is_true(a < b)
    assert.is_false(c < d)
  end)

  it("works with same line", function()
    local a = Position.new(5, 2)
    local b = Position.new(5, 3)
    local c = Position.new(10, 6)
    local d = Position.new(10, 1)

    assert.is_true(a < b)
    assert.is_false(c < d)
  end)
end)

describe("`==`", function()
  it("works", function()
    local a = Position.new(7, 1)
    local b = Position.new(7, 1)
    local c = Position.new(2, 8)
    local d = Position.new(3, 8)

    assert.is_true(a == b)
    assert.is_false(c == d)
  end)
end)