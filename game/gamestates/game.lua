local Paddle = require "classes.paddle"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}

function state:enter()

	Paddle.create("player")

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
