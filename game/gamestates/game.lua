local Paddle = require "classes.paddle"
local Ball = require "classes.ball"
local Brick = require "classes.brick"


--MODULE FOR THE GAMESTATE: GAME--

local state = {}

function state:enter()

	Paddle.create("player")

	local x, y = O_WIN_W/2, O_WIN_H/2 --Initial ball position in the middle of the screen
	local angle = math.pi/2 + love.math.random(2*math.pi/8) - math.pi/8 --Get an initial random angle between 247.5 and 292.5
	local dx, dy = math.cos(angle), math.sin(angle) --Random initial direction for ball, going downwards
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

	--Start moving the ball if its static after touching the screen
	local b = Util.findId("ball")
	if b and b.static then
		b.static = false
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

function state:mousepressed(x, y, button, isTouch)

	local p = Util.findId("player")
	if p then
		p:mousepressed(x, y, button, isTouch)
	end

	--Start moving the ball if its static after touching the screen
	local b = Util.findId("ball")
	if b and b.static then
		b.static = false
	end

	if button == 2 then

		local w, h = FreeRes.windowDistance()
		local scale = FreeRes.scale()
		x = x - w
		x = x*(1/scale)
		y = y - h
		y = y*(1/scale)

		Brick.create(x,y,"regular")
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
