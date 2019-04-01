io.stdout:setvbuf("no")
-- require('main_loop')
-- require("run") -- this makes sure that we can skip framedrawing and such
settings = require("settings")
require("util") -- some utilty functions
require("actor")


--[[
TODO:


--]]



function love.load(arg)
	-- This canvas containts the current track as a background image.
	-- Drawing this before anything else means that we only have to draw this image to memory once
	debug = {
		["showMouseCoordsWhenPressed"] = false
	}
	
	actors = getFirstAnimals(settings.sim.animalCount)

	love.window.setTitle("Running track: " .. (settings.trackFileName or "default"))
end

function love.update(dt)
	for _, d in pairs(units) do
		d:update(dt)
	end

end -- love.update

function love.draw(dt)
	love.graphics.setCanvas()
	love.graphics.setColor(1,1,1,1)

	for _, d in pairs(actors) do
		d:draw()
	end
	if settings.drawInputs then
	-- just draw the one input node if wanted.
	cars[1]:drawInputs()
	end
	-- love.event.push('quit') -- for testing purposes we can quit after exactly one update and draw
end

function love.keypressed(k)
	if k == 'escape' then
		love.event.push('quit')
	end
	print(k)
end

function love.mousepressed( x, y, button, istouch, presses)
	if debug.showMouseCoordsWhenPressed then
		print(x, y)
	end
end