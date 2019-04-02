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

function world.new(width, height)

    local _world = setmetatable({ -- the 'class instance'
        width = width,
        height = height,
        tiles = {}, -- [x][y]=tile
        listTiles = {},
        listTilesDirty = true, -- whether or not the tiles have changed references
    },
        worldMt
    )

    -- Fill world with tiles:
    local tilesHeight = Settings.sim.worldHeight / Settings.sim.tileSize
    local tilesWidth  = Settings.sim.worldWidth  / Settings.sim.tileSize
    
    -- smoothing level of 3 seems to be quite nice.
    local nutritionPerLocation = noise(tilesHeight, tilesWidth, 3)
    local npl = nutritionPerLocation

    for x = 0, tilesWidth, 1 do
        for y = 0, tilesHeight, 1 do
            _world.tiles[x][y] = C.tile.new(x, y, Settings.sim.tileSize, Settings.sim.tileSize)
            _world.tiles[x][y]:setNutrition(npl[x][y])
        end
    end

    return _world
end

function world:test()
    print("Test")
end

function world:draw(left, top, width, height)
    for i, d in pairs(self:getTileList()) do
        if RectangleCollide(d:getX(), d:getY(), d:getWidth(), d:getHeight(), left, top, width, height) then
            -- if the tile is inside the visible viewport
            d:draw()
        end
    end
end

function world:getTileList()
    if self.listTilesDirty then
        local tiles = {}
        for xIndex, yTable in ipairs(self.tiles) do
            for yIndex, tile in ipairs(yTable) do
                table.insert(tiles, tile)
            end
        end
        self.listTilesDirty = false
        self.listTiles = tiles
    end
    return self.listTiles
end

return world
