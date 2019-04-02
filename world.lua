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

    local newWorld = setmetatable({ -- the 'class instance'
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
    local nutritionPerLocation = noise(tilesWidth, tilesHeight, 3)
    local npl = nutritionPerLocation
    
    local STSize = Settings.sim.tileSize

    for x = 1, tilesWidth, 1 do
        newWorld.tiles[x] = {}
        for y = 1, tilesHeight, 1 do
            newWorld.tiles[x][y] = C.tile.new((x-1) * STSize, (y-1) * STSize, STSize, STSize)
            newWorld.tiles[x][y]:setNutrition(npl[x][y])
        end
    end
    newWorld.listTilesDirty = true
    -- We've edited the references to the tiles so this flag must be set
    return newWorld
end

function world:draw(left, top, width, height)
    for i, d in pairs(self:getTileList()) do
        if RectangleCollide(d:getX(), d:getY(), d:getWidth(), d:getHeight(), left, top, width, height) then
            -- if the tile is inside the visible viewport
        end
        d:draw()
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
