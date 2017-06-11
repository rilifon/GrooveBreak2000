local Button = require "classes.button"
local Text   = require "classes.text"


--MODULE FOR THE GAMESTATE: CUSTOM LEVELS--

local state = {}

--LOCAL VARIABLES--

local switch = nil --If game should swith to another state

--LOCAL FUNCTIONS--

local checkCollisions
local createCustomLevelsButtons

--STATE FUNCTIONS--

function state:enter()

	switch = nil

	local img = IMAGE(0,0,IMG_BG)
	img:addElement(DRAW_TABLE.BG, nil, "bg")
	img.sx, img.sy = 3, 3


	--Title
	Text.create(400, 200, "CUSTOM LEVELS", "nevis", 90)

	createCustomLevelsButtons()

end

function state:leave()

	Util.destroyAll("force")

end


function state:update(dt)
	if switch == "menu" then
		Gamestate.switch(GS.MENU)
	elseif switch == "editor" then
		Gamestate.switch(GS.LVL_EDT)
	end

	Util.updateDrawTable(dt)

	Util.updateTimers(dt)

	Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)

	if key == "escape" then
		switch = "menu"
		--love.keyboard.setTextInput( true, 0, 0, O_WIN_W, 500 )
	else
		Util.defaultKeyPressed(key)    --Handles keypressing for general stuff
	end

end

function state:mousepressed(x, y, button, istouch)

	if isTouch then return end

	checkButtonsCollisions(x, y)

end

function state:touchpressed(id, x, y, dx, dy, pressure)

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

	--Check collision with custom level buttons
	custom_buts = Util.findSubtype("custom_level_button")
	if custom_buts then
		for but in pairs(custom_buts) do
			if Util.pointInRect({x = x, y = y}, {x = but.pos.x, y = but.pos.y, w = but.w, h = but.h}) then
				but.func()
			end
		end
	end
end

function createCustomLevelsButtons()

	local width = 800 --Width of the button
	local height = 80 --Height of the button
	local initial_x = O_WIN_W/2 - width/2 --X position of all buttons
	local initial_y = 500 --Initial y position of all buttons
	local gap = 30 --Gap between each button
	local text
	for i,level in ipairs(CUSTOM_LEVELS) do
		local index = i
		text = level.name
		--Create level button
		Button.createRegularButton(initial_x, initial_y + (i-1)*(height+gap), width, height, Color.purple(), text,
			function()
				LEVEL_TO_LOAD = level
				Gamestate.switch(GS.GAME)
			end, "custom_level_button")

		--Create delete button
		Button.createRegularButton(initial_x + width + 20, initial_y + (i-1)*(height+gap), height, height, Color.red(), "X",
			function()

				for but in pairs(Util.findSubtype("custom_level_button")) do
					but.death = true
				end

				table.remove(CUSTOM_LEVELS, index)
				Gamestate.switch(GS.GAME)
				Gamestate.switch(GS.CSTM_LVLS)
			end, "custom_level_button")
	end
end

--Return state functions
return state
