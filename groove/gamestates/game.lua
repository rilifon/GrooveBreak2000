local Paddle = require "classes.paddle"
local Ball = require "classes.ball"
local Brick = require "classes.brick"
local Text = require "classes.text"
local Button = require "classes.button"
local LifeInd = require "classes.life_indicator"



--MODULE FOR THE GAMESTATE: GAME--

local state = {}

--LOCAL VARIABLES--

local switch = nil --If game should swith to another state
local you_won --If player has won the game already
local player_lives --How many lives the player start with
local is_paused = false
local create_ball_handle

--End game screen
local win_texts = {"YOU WON", "CONGRATULATIONS", "YOU DA BEST"}
local lose_texts = {"GAMEOVER", "YOU LOST"}
local won_game_text
local first_button
local second_button


--LOCAL FUNCTION--

local loadLevel
local checkWinCondition
local startGame
local startGameOver
local checkButtonsCollisions
local spawnBall

--STATE FUNCTIONS--

function state:enter()

	switch = nil

	local img = IMAGE(0,0,IMG_BG)
	img:addElement(DRAW_TABLE.BG, nil, "bg")
	img.sx, img.sy = 3, 3

	startGame()

end

function state:leave()

	Util.destroyAll("force")

	if create_ball_handle then
		MAIN_TIMER:cancel(create_ball_handle)
	end

end


function state:update(dt)

	if switch == "menu" then
		Gamestate.switch(GS.MENU)
	end

	if not is_paused then
		checkWinCondition()

		Util.updateDrawTable(dt)

		Util.updateTimers(dt)
	end

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

	--Start moving the ball if its static after touching the screen
	local b = Util.findId("ball")
	if b and b.static then
		b.static = false
	end

	checkButtonsCollisions(x, y)

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

	if isTouch then return end

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

	checkButtonsCollisions(x, y)

end

function state:mousereleased(x, y, button, isTouch)

	if isTouch then return end

	local p = Util.findId("player")
	if p then
		p:mousereleased(x, y, button, isTouch)
	end

end

function state:keypressed(key)

	if key == "escape" then
		switch = "menu"
	elseif key == "p" then
		is_paused = not is_paused
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

	if you_won or switch then return end

	if Util.tableLen(Util.findSubtype("bricks")) <= 0 then
		you_won = true

		--Create win text
		local text = Util.randomElement(win_texts)
		local font = Font.get("nevis", 120)
		local tx = font:getWidth(text)
		local ty = font:getHeight(text)
		won_game_text = Text.create(O_WIN_W/2 - tx/2, O_WIN_H/2 - ty/2, text, "nevis", 120)

		--Create "retry" or "next level" button
		if LEVEL_TO_LOAD then
			if LEVEL_TO_LOAD.type == "custom" then
				local width, height = 400, 100
				local x, y =  O_WIN_W/2 - width/2, O_WIN_H/2 + ty/2 + 80
				first_button = Button.createRegularButton(x, y, width, height, Color.red(), "retry",
					function()
						won_game_text.death = true
						first_button.death = true
						second_button.death = true
						startGame()
					end
				)
				first_button.font_size = 70
				first_button.border_radius = 30
			else
				local width, height = 400, 100
				local x, y =  O_WIN_W/2 - width/2, O_WIN_H/2 + ty/2 + 80
				first_button = Button.createRegularButton(x, y, width, height, Color.red(), "next level",
					function()
						won_game_text.death = true
						first_button.death = true
						second_button.death = true
						LEVEL_TO_LOAD = LEVELS[LEVEL_TO_LOAD.next]
						startGame()
					end
				)
				first_button.font_size = 70
				first_button.border_radius = 30
			end

			--Go back to menu button
			local width, height = 400, 100
			local x, y =  O_WIN_W/2 - width/2, O_WIN_H/2 + ty/2 + 200
			second_button = Button.createRegularButton(x, y, width, height, Color.red(), "go back",
				function()
					Gamestate.switch(GS.MENU)
				end
			)
			second_button.font_size = 70
			second_button.border_radius = 30
		else
			local width, height = 400, 100
			local x, y =  O_WIN_W/2 - width/2, O_WIN_H/2 + ty/2 + 200
			second_button = Button.createRegularButton(x, y, width, height, Color.red(), "go back",
				function()
					Gamestate.switch(GS.MENU)
				end
			)
			second_button.font_size = 70
			second_button.border_radius = 30
		end

		--Remove ball
		local b = Util.findId("ball")
		if b and not b.death then
			b.death = true
			FX.explosion(b.pos.x, b.pos.y, Color.red(), 40, 8, 500)
		end

	end

end

function startGame()

	you_won = false

	--Create Paddle
	local p = Util.findId("player")
	if not p then
		p = Paddle.create("player")
	else
		p.pos.x = O_WIN_W/2 - p.w/2
	end
	--Restart paddle lives
	p.lives = p.initial_lives

	--Create Life Indicator
	local life_ind = Util.findId("life_indicator")
	if not life_ind then
		life_ind = LifeInd.create(50, 50)
	end

	--Create ball
	spawnBall()

	--Load level
	if LEVEL_TO_LOAD then
		loadLevel(LEVEL_TO_LOAD)
	end


end

--Creates a ball
function spawnBall()
	local x, y = O_WIN_W/2, O_WIN_H/2 --Initial ball position in the middle of the screen
	local angle = math.pi/2 + love.math.random()*2*math.pi/8 - math.pi/8 --Get an initial random angle between 247.5 and 292.5
	local dx, dy = math.cos(angle), math.sin(angle) --Random initial direction for ball, going downwards
	Ball.create(x, y, dx, dy, "ball")
end

function startGameOver()

	--Create gameover text
	local text = Util.randomElement(lose_texts)
	local font = Font.get("nevis", 120)
	local tx = font:getWidth(text)
	local ty = font:getHeight(text)
	won_game_text = Text.create(O_WIN_W/2 - tx/2, O_WIN_H/2 - ty/2, text, "nevis", 120)

	if LEVEL_TO_LOAD then
		--Create "retry" button
		local width, height = 400, 100
		local x, y =  O_WIN_W/2 - width/2, O_WIN_H/2 + ty/2 + 80
		first_button = Button.createRegularButton(x, y, width, height, Color.red(), "retry",
			function()
				won_game_text.death = true
				first_button.death = true
				second_button.death = true
				startGame()
			end
		)
		first_button.font_size = 70
		first_button.border_radius = 30

		--Go back to menu button
		local width, height = 400, 100
		local x, y =  O_WIN_W/2 - width/2, O_WIN_H/2 + ty/2 + 200
		second_button = Button.createRegularButton(x, y, width, height, Color.red(), "go back",
			function()
				Gamestate.switch(GS.MENU)
			end
		)
		second_button.font_size = 70
		second_button.border_radius = 30
	end
end

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

--Function to be called when the gall hits the bottom of the screen
Signal.register('lost_live', function()
	local p = Util.findId("player")

	if p then
		if p.lives <= 0 then return end

		p.lives = p.lives - 1 --Update paddles lives

		if p.lives > 0 then
			create_ball_handle = MAIN_TIMER:after(1,
				function()
					spawnBall()
				end
			)
		else
			startGameOver()
		end

	end

end)

--Return state functions
return state
