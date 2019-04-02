io.stdout:setvbuf("no")
-- require('main_loop')
-- require("run") -- this makes sure that we can skip framedrawing and such

function love.load(arg)
	require("util")
	-- First we load the util functions, these can be used by everything
	Settings = require("settings")
	-- Secondly we get the settings, these can influence anything, and can use the util functions
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	-- we set the filtering mode to nearest neighbour, which is better for pixel perfect
	local gamera = require("lib.gamera")
	local borderSize = Settings.interface.outsizeSize
	Camera = gamera.new(-borderSize, -borderSize, Settings.sim.worldWidth + (borderSize*2), Settings.sim.worldHeight + (borderSize * 2))
	-- Then we get the camera and we make a new camera with the worldsize
	C = require("classes")
	-- this requires a file with requires for all the classes

	debug = { -- Set up some debug switches
		["showMouseCoordsWhenPressed"] = false,
		["showMouseCoordsWhenScroll"] = true,
	}

	-- The world uses a small noise method
	require("noise")

	-- Set up the world
	World = C.world.new(Settings.sim.worldWidth, Settings.sim.worldHeight)

	Animals = GetFirstAnimals(Settings.sim.animalCount)


	love.window.setTitle("Stay-Alive")
	-- This means that keypressed is called every frame instead of only on keydown
	love.keyboard.setKeyRepeat(true)
	-- prepare the keypressed values so that we can use the key values in the update call
	WPressed, APressed, SPressed, DPressed = false, false, false, false
	WheelUp, WheelDown = false, false
	ScrollLocationX, ScrollLocationY = 0, 0

end

function love.update(dt)
-- Handling input
	local dx, dy, ds = 0, 0, 0 -- scale defaults to 0, dx and dy default to the movement from the mouse
	if WPressed then
		dy = dy - (Settings.interface.movementSpeed * dt)
	end
	if SPressed then
		dy = dy + (Settings.interface.movementSpeed * dt)
	end

	if APressed then
		dx = dx - (Settings.interface.movementSpeed * dt)
	end
	if DPressed then
		dx = dx + Settings.interface.movementSpeed * dt
	end

	if WheelDown then
		ds = ds - Settings.interface.zoomSpeed
	end
	if WheelUp then
		ds = ds + Settings.interface.zoomSpeed
	end

	-- first we set the scroll event as the new middle, after that we move away from it based on the keypressed deltas
	if ScrollLocationX ~= 0 or ScrollLocationY ~= 0 then
		Camera:setPosition(ScrollLocationX, ScrollLocationY)
	end

	if dx ~= 0 or dy ~= 0 then
		-- if the camera should move
		Camera:move(dx, dy)
	end

	if ds ~= 0 then
		-- if the scalechange is not nothing
		Camera:changeScale(ds)
	end
	-- reset all values to false and 0 to make sure we don't repeat actions
	WPressed, APressed, SPressed, DPressed, WheelDown, WheelUp, ScrollLocationX, ScrollLocationY = false, false, false, false, false, false, 0, 0
-- Handling input

end -- love.update

function love.draw(dt)
	love.graphics.setColor(1,1,1,1)
	love.graphics.setLineWidth(math.floor(Settings.interface.borderWidth * Camera:getScale()))

	Camera:draw(function(l,t,w,h)
		-- Placing the background on the map
		love.graphics.rectangle("line", 0, 0, Settings.sim.worldWidth, Settings.sim.worldHeight)
		love.graphics.rectangle("fill", 100, 100, 50, 50)
	end)

	-- love.event.push('quit') -- for testing purposes we can quit after exactly one update and draw
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.push('quit')
	end
	if k == "w" then
		WPressed = true
	end
	if k == "a" then
		APressed = true
	end	
	if k == "s" then
		SPressed = true
	end
	if k == "d" then
		DPressed = true
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
		WheelUp = true
    elseif y < 0 then
		WheelDown = true
	end
	
	-- When the wheel is moved we want to move the camera in that direction for about 1/2 of the way I suppose
	-- the distance between the mouse and the centre of the screen is half of the moving distance

	local x, y = love.mouse.getPosition()
	ScrollLocationX, ScrollLocationY = Camera:toWorld(x, y) -- where we want to centre the screen. All other mutations will be based on this.
	if debug.showMouseCoordsWhenScroll then
		print(x, y)
		print(ScrollLocationX, ScrollLocationY)
	end
end