--[[
Class file for the tiles on the ground

--]]

local tile = {}

-- Private attributes and methods

local tileMt = {__index = tile}

local function test()
  return true
end

-- Public methods

function tile.new(x, y)

  local _world = setmetatable({ -- the 'class instance'
    x = x,
    y = y,
  }, tileMt)

  return _world
end

function tile:test()
    print("Test")
    print(self.x, self.y)
end

return tile
