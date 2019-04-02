--[[
Class file for the World

--]]

local world = {}

-- Private attributes and methods

local worldMt = {__index = world}

local function test()
  return true
end

-- Public methods

function world.new(x, y)

  local _world = setmetatable({ -- the 'class instance'
    x = x,
    y = y,
  }, worldMt)

  -- Fill world with tiles

  return _world
end

function world:test()
    print("Test")
    print(self.x, self.y)
end

return world
