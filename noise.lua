-- Fill each pixel in a grid with simplex noise.
--      And smooth it thrice for a nice effect
function noise(width, height, smoothingAmount)
    local grid = {}

    for x = 1, width do
        for y = 1, height do
            grid[x] = grid[x] or {}
            grid[x][y] = love.math.noise( x + love.math.random(), y + love.math.random() )
        end
    end

    for _=1, smoothingAmount, 1 do
        grid = smoothAverage8(grid)
    end

    return grid
end

-- Smooth by:
--      this is the delta on top of the average of the 8 cells surrounding it
function smoothAverage8(grid)
    for x = 1, #grid do
        for y = 1, #grid[x] do
            grid[x][y] = clamp(averageSurrounding8(x, y, grid) +
                        grid[x][y] -
                        0.5, 0, 1)
        end
    end
    return grid
end

function averageSurrounding8(x, y, grid)
    local tab = {}
    for x_ = x-1, x+1, 1 do
        for y_ = y-1, y+1, 1 do
            if not (outBoundsX(x_, grid) or outBoundsY(y_, grid)) then
                table.insert(tab, grid[x_][y_])
            end
        end
    end
    return table.average(tab)
end

function outBoundsX(value, grid)
    return not (value > 0 and value <= #grid)
end

function outBoundsY(value, grid)
    return not (value > 0 and value <=#grid[1])
end
