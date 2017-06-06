--MODULE FOR THE GAMESTATE: LEVEL EDITOR--

local state = {}

--LOCAL VARIABLES--

local switch = nil --If game shoudl swith to another state

--LOCAL FUNCTIONS--


--STATE FUNCTIONS--

function state:enter()


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

function state:keypressed(key)

    Util.defaultKeyPressed(key)    --Handles keypressing for general stuff

end

function state:mousepressed(x, y, button, istouch)

	local w, h = FreeRes.windowDistance()
    local scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)


end

function state:touchpressed(id, x, y, dx, dy, pressure)

	local w, h = FreeRes.windowDistance()
	local scale = FreeRes.scale()
	x = x - w
	x = x*(1/scale)
	y = y - h
	y = y*(1/scale)


end


--LOCAL FUNCTIONS


--Return state functions
return state
