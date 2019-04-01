io.stdout:setvbuf("no")
-- require('main_loop')
-- require("run") -- this makes sure that we can skip framedrawing and such

function love.load(arg)
	require("util")
	-- First we load the util functions, these can be used by everything
	settings = require("settings")
	-- Secondly we get the settings, these can influence anything, and can use the util functions
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	-- we set the filtering mode to nearest neighbour, which is better for pixel perfect
	local gamera = require("lib.gamera")
	local borderSize = settings.interface.outsizeSize
	cam = gamera.new(-borderSize, -borderSize, settings.sim.worldWidth + (borderSize*2), settings.sim.worldHeight + (borderSize * 2))
	-- Then we get the camere and we make a new camera with the worldsize
	require("classes")
	-- this requires a file with requires for all the classes

	debug = { -- Set up some debug switches
		["showMouseCoordsWhenPressed"] = false
	}
	
	actors = getFirstAnimals(settings.sim.animalCount)

	love.window.setTitle("Stay-Alive")
	-- This means that keypressed is called every frame instead of only on keydown
	love.keyboard.setKeyRepeat(true)
	-- prepare the keypressed values so that we can use the key values in the update call
	w, a, s, d = false, false, false, false
	wheelUp, wheelDown = false, false
	scrollx, scrolly = 0, 0

end

function love.update(dt)
-- Handling input
	dx, dy, ds = scrollx, scrolly, 0 -- scale defaults to 0, dx and dy default to the movement from the mouse
	if w then
		dy = dy - (settings.interface.movementSpeed * dt)
	end
	if s then
		dy = dy + (settings.interface.movementSpeed * dt)
	end

	if a then
		dx = dx - (settings.interface.movementSpeed * dt)
	end
	if d then
		dx = dx + settings.interface.movementSpeed * dt
	end

	if wheelDown then
		ds = ds - settings.interface.zoomSpeed
	end
	if wheelUp then
		ds = ds + settings.interface.zoomSpeed
	end

	if dx ~= 0 or dy ~= 0 then
		-- if the camera should move
		cam:move(dx, dy)
	end

	if ds ~= 0 then
		-- if the scalechange is not nothing
		cam:changeScale(ds)
	end
	w, a, s, d, wheelDown, wheelUp, scrollx, scrolly = false, false, false, false, false, false, 0, 0
-- Handling input

end -- love.update

function love.draw(dt)
	love.graphics.setColor(1,1,1,1)
	love.graphics.setLineWidth(math.floor(settings.interface.borderWidth * cam:getScale()))

	cam:draw(function(l,t,w,h)
		-- Placing the background on the map
		love.graphics.rectangle("line", 0, 0, settings.sim.worldWidth, settings.sim.worldHeight)
		love.graphics.rectangle("fill", 100, 100, 50, 50)
	end)

	-- love.event.push('quit') -- for testing purposes we can quit after exactly one update and draw
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.push('quit')
	end
	if k == "w" then
		w = true
	end
	if k == "a" then
		a = true
	end	
	if k == "s" then
		s = true
	end
	if k == "d" then
		d = true
	end
	print(k)
end

function love.mousepressed(x, y, button, istouch, presses)
	if debug.showMouseCoordsWhenPressed then
		print(x, y)
	end
end

function love.wheelmoved(x, y)
    if y > 0 then
		wheelUp = true
    elseif y < 0 then
		wheelDown = true
	end
	
	-- When the wheel is moved we want to move the camera in that direction for about 1/2 of the way I suppose
	-- the distance between the mouse and the centre of the screen is half of the moving distance

	local x, y = love.mouse.getPosition()
	local sx, sy = love.graphics.getPixelDimensions()
	scrollx = - (((sx/2) - x) * cam:getScale())
	scrolly = - (((sy/2) - y) * cam:getScale())
end