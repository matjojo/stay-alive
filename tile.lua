--[[
Class file for the tiles on the ground

--]]

local tile = {}

-- Private attributes and methods

local tileMt = {__index = tile}

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

function tile:getX()
    return self.x
end

function tile:getY()
    return self.y
end

function tile:getWidth()
    return self.width
end

function tile:getHeight()
    return self.height
end

function tile:setNutrition(newNutrition)
    self.nutrition = newNutrition
end

function tile:draw()
    love.graphics.setColor(0, self.nutrition, 0, 1) -- channels red and blue are zero, green is the nutrition value and aplha is 1 of course
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return tile
