local Button = require "classes.button"


--MODULE FOR THE GAMESTATE: MENU--

local state = {}

--LOCAL VARIABLES--

local switch = nil --If game should swith to another state

--LOCAL FUNCTIONS--

local checkCollisions

--STATE FUNCTIONS--

function state:enter()

	switch = nil

	--Start Game button
	Button.createRegularButton(400, 400, 400, 400, Color.red(), "Start Game", function() switch = "game" end)

	--Custom Levels button
	Button.createRegularButton(400, 900, 400, 400, Color.red(), "Custom Levels", function() switch = "custom" end)

	--Start Editor button
	Button.createRegularButton(400, 1400, 400, 400, Color.red(), "Start Editor", function() switch = "editor" end)


end

function state:leave()

	Util.destroyAll("force")

end


function state:update(dt)
	if switch == "game" then
		Gamestate.switch(GS.GAME)
	elseif switch == "custom" then
		Gamestate.switch(GS.CSTM_LVLS)
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

    Util.defaultKeyPressed(key)    --Handles keypressing for general stuff

end

function state:mousepressed(x, y, button, istouch)

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
end

--Return state functions
return state