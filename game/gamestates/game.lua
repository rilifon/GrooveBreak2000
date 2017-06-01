local Paddle = require "classes.paddle"
local Ball = require "classes.ball"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}

function state:enter()

	Paddle.create("player")

	local x, y = O_WIN_W/2, O_WIN_H/2 --Initial ball position in the middle of the screen
	local dx, dy = love.math.random(100) - 50, love.math.random(50) --Random initial direction for ball, going downwards
	Ball.create(x, y, dx, dy, "ball")

end

function state:leave()

end


function state:update(dt)

	Util.updateDrawTable(dt)

	Util.updateTimers(dt)

	Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:touchpressed(...)
	local p = Util.findId("player")

	if p then
		p:touchpressed(...)
	end

end

function state:touchreleased(...)
	local p = Util.findId("player")

	if p then
		p:touchreleased(...)
	end

end

function state:touchmoved(...)
	local p = Util.findId("player")

	if p then
		p:touchmoved(...)
	end

end

function state:mousepressed(...)
	local p = Util.findId("player")

	if p then
		p:mousepressed(...)
	end

end

function state:mousereleased(...)
	local p = Util.findId("player")

	if p then
		p:mousereleased(...)
	end

end

function state:keypressed(key)

    Util.defaultKeyPressed(key)

end

--Return state functions
return state
