local Paddle = require "classes.paddle"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}

function state:enter()

	Paddle.create("player")

end

function state:leave()

end


function state:update(dt)

	Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:touchpressed(id, x, y, dx, dy, pressure)
	local p = Util.findId("player")

	if p then
		p:touchpressed(id, x, y, dx, dy, pressure)
	end
	
end

function state:keypressed(key)

    Util.defaultKeyPressed(key)

end

--Return state functions
return state
