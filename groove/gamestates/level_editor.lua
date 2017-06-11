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

	local img = IMAGE(0,0,IMG_BG)
	img:addElement(DRAW_TABLE.BG, nil, "bg")
	img.sx, img.sy = 3, 3


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

	local editor_box = Util.findId("editor_box")
	if editor_box then
		editor_box:touchpressed(id, x, y, dx, dy, pressure)
	end

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

	if isTouch then return end

	local bricks = Util.findSubtype("bricks")

	if bricks then
		for brick in pairs(bricks) do
			brick:mousepressed(x, y, button, isTouch)
		end
	end

	local editor_box = Util.findId("editor_box")
	if editor_box then
		editor_box:mousepressed(x, y, button, isTouch)
	end

	if button == 1 then

		checkButtonsCollisions(x, y)

	elseif button == 2 then

		Brick.createDrag(x,y,"regular_ice")

	end

end

function state:mousereleased(x, y, button, isTouch)

	if isTouch then return end

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
