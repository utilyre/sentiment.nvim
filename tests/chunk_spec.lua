local Chunk = require("sentiment.Chunk")
local Viewport = require("sentiment.Viewport")
local Position = require("sentiment.Position")

describe("`:line()`", function()
  it("works with ASCII", function()
    local chunk = Chunk.new(Viewport.new(11, 16), {
      "", -- 11
      "hi there", -- 12
      "this is third", -- 13
      "fourth", -- 14
      "hello world", -- 15
      "and the last line", -- 16
    })

    assert.is.equal(nil, chunk:line(1))
    assert.is.equal(nil, chunk:line(10))
    assert.is.equal("", chunk:line(11))
    assert.is.equal("hello world", chunk:line(15))
    assert.is.equal(nil, chunk:line(17))
    assert.is.equal(nil, chunk:line(30))
  end)

  it("works with Unicode", function()
    local chunk = Chunk.new(Viewport.new(25, 28), {
      "😀 hello", -- 25
      "wanna play some 🎮 games?", -- 26
      "", -- 27
      "You'll be 💀", -- 28
    })

    assert.is.equal(nil, chunk:line(13))
    assert.is.equal(nil, chunk:line(24))
    assert.is.equal("", chunk:line(27))
    assert.is.equal("You'll be 💀", chunk:line(28))
    assert.is.equal(nil, chunk:line(29))
    assert.is.equal(nil, chunk:line(80))
  end)
end)

describe("`:chars()`", function()
  it("works with ASCII", function()
    local chunk = Chunk.new(Viewport.new(14, 17), {
      "hi", -- 14
      "stuff", -- 15
      "E", -- 16
      "", -- 17
    })

    local iter = chunk:chars()
    assert.is.same({ Position.new(14, 1), "h" }, { iter() })
    assert.is.same({ Position.new(14, 2), "i" }, { iter() })
    assert.is.same({ Position.new(15, 1), "s" }, { iter() })
    assert.is.same({ Position.new(15, 2), "t" }, { iter() })
    assert.is.same({ Position.new(15, 3), "u" }, { iter() })
    assert.is.same({ Position.new(15, 4), "f" }, { iter() })
    assert.is.same({ Position.new(15, 5), "f" }, { iter() })
    assert.is.same({ Position.new(16, 1), "E" }, { iter() })
    assert.is.same({ Position.new(17, 1), "" }, { iter() })
  end)
end)
