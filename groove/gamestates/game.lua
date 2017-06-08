local Paddle = require "classes.paddle"
local Ball = require "classes.ball"
local Brick = require "classes.brick"
local Text = require "classes.text"
local Button = require "classes.button"



--MODULE FOR THE GAMESTATE: GAME--

local state = {}

--LOCAL VARIABLES--

local switch = nil --If game should swith to another state
local you_won = false
local win_texts = {"YOU WON", "CONGRATULATIONS", "YOU DA BEST"}

--LOCAL FUNCTION--

local loadLevel
local checkWinCondition

--STATE FUNCTIONS--

function state:enter()

	switch = nil

	Paddle.create("player")

	local x, y = O_WIN_W/2, O_WIN_H/2 --Initial ball position in the middle of the screen
	local angle = math.pi/2 + love.math.random()*2*math.pi/8 - math.pi/8 --Get an initial random angle between 247.5 and 292.5
	local dx, dy = math.cos(angle), math.sin(angle) --Random initial direction for ball, going downwards
	Ball.create(x, y, dx, dy, "ball")

	if LEVEL_TO_LOAD then
		loadLevel(LEVEL_TO_LOAD)
	end

end

function state:leave()

	Util.destroyAll("force")

end


function state:update(dt)

	if switch == "menu" then
		Gamestate.switch(GS.MENU)
	end

	checkWinCondition()

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

		Brick.create(x,y,"tough_ice")

	end

end

function state:mousereleased(...)
	local p = Util.findId("player")
	if p then
		p:mousereleased(...)
	end

end

function state:keypressed(key)

	if key == "escape" then
		switch = "menu"
	else
    	Util.defaultKeyPressed(key)
	end

end

--LOCAL FUNCTIONS

function loadLevel(level)

	for _,brick in pairs(level.bricks) do
		Brick.create(brick.x, brick.y, brick.type)
	end

end

function checkWinCondition()

	if you_won then return end

	if Util.tableLen(Util.findSubtype("bricks")) <= 0 then
		you_won = true

		--Create win text
		local text = Util.randomElement(win_texts)
		local font = Font.get("nevis", 120)
		local tx = font:getWidth(text)
		local ty = font:getHeight(text)
		Text.create(O_WIN_W/2 - tx/2, O_WIN_H/2 - ty/2, text, "nevis", 120)

		--Remove ball
		local b = Util.findId("ball")
		if b and not b.death then
			b.death = true
			FX.explosion(b.pos.x, b.pos.y, Color.red(), 40, 8, 500)
		end

	end

end

--Return state functions
return state
