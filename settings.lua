return {
    ["sim"] = { -- all simulator settings
        ["animalCount"] = 200,
        ["worldHeight"] = 1000,
        ["worldWidth"] = 2000,
    },
    ["interface"] = { -- user/interface settings
        ["movementSpeed"] = 2000,
        -- amount of mapsize to move per second
        ["zoomSpeed"] = 1/2,
        -- the zoom amount to change per mousewheel turn.
        -- The zoomlevel is at 1 at base, and at 2 it'll be zoomed double
        ["outsizeSize"] = 100,
        -- The size of a black border around the world that allows you to scroll a bit further than the sides of the map
        ["borderWidth"] = 5,
        -- this is the size that the white border around the world will try to stay at
    },

}