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

function tile.new(x, y, width, height)

  local _world = setmetatable({ -- the 'class instance'
    x = x,
    y = y,
    width = width,
    height = height,
    nutrition = 0,
  }, tileMt)

  return _world
end

function tile:setNutrition(newNutrition)
    self.nutrition = newNutrition
end

return tile
