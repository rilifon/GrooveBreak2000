local Editor_Box = require "classes.editor_box"
local Brick = require "classes.brick"


--MODULE FOR THE GAMESTATE: LEVEL EDITOR--

local state = {}

--LOCAL VARIABLES--

local switch = nil --If game should swith to another state

--LOCAL FUNCTIONS--

local checkCollisions

--STATE FUNCTIONS--

function state:enter()

	switch = nil

	Editor_Box.create()

end

function state:leave()

	Util.destroyAll("force")

end


function state:update(dt)

	if switch == "menu" then
		Gamestate.switch(GS.MENU)
	end

	Util.updateDrawTable(dt)

	Util.updateTimers(dt)

	Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:touchpressed(id, x, y, dx, dy, pressure)

	local bricks = Util.findSubtype("bricks")

	if bricks then
		for brick in pairs(bricks) do
			brick:touchpressed(id, x, y, dx, dy, pressure)
		end
	end

	local w, h = FreeRes.windowDistance()
	local scale = FreeRes.scale()
	x = x - w
	x = x*(1/scale)
	y = y - h
	y = y*(1/scale)

	checkButtonsCollisions(x, y)

end

function state:touchreleased(...)

	local bricks = Util.findSubtype("bricks")

	if bricks then
		for brick in pairs(bricks) do
			brick:touchreleased(...)
		end
	end

end

function state:touchmoved(...)

	local bricks = Util.findSubtype("bricks")

	if bricks then
		for brick in pairs(bricks) do
			brick:touchmoved(...)
		end
	end

end

function state:mousepressed(x, y, button, isTouch)

	local bricks = Util.findSubtype("bricks")

	if bricks then
		for brick in pairs(bricks) do
			brick:mousepressed(x, y, button, isTouch)
		end
	end

	if button == 2 then

		local w, h = FreeRes.windowDistance()
		local scale = FreeRes.scale()
		x = x - w
		x = x*(1/scale)
		y = y - h
		y = y*(1/scale)

		Brick.createDrag(x,y,"regular")
	elseif button == 1 then

		local w, h = FreeRes.windowDistance()
		local scale = FreeRes.scale()
		x = x - w
		x = x*(1/scale)
		y = y - h
		y = y*(1/scale)

		checkButtonsCollisions(x, y)

	end

end

function state:mousereleased(x, y, button, isTouch)

	local bricks = Util.findSubtype("bricks")

	if bricks then
		for brick in pairs(bricks) do
			brick:mousereleased(x, y, button, isTouch)
		end
	end

end

function state:keypressed(key)

	if key == "escape" then
		switch = "menu"
	else
    	Util.defaultKeyPressed(key)    --Handles keypressing for general stuff
	end

end


function state:touchpressed(id, x, y, dx, dy, pressure)

	local w, h = FreeRes.windowDistance()
    local scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

	checkButtonsCollisions(x, y)


end


--LOCAL FUNCTIONS


--Iterate through all buttons and check for collision with (x,y) given
function checkButtonsCollisions(x, y)

	--Check collision with regular buttons
	reg_buts = Util.findSubtype("regular_buttons")
	if reg_buts then
		for but in pairs(reg_buts) do
			if Util.pointInRect({x = x, y = y}, {x = but.pos.x, y = but.pos.y, w = but.w, h = but.h}) then
				but.func()
			end
		end
	end
end

--Return state functions
return state
