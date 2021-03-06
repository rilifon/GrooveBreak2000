local Button = require "classes.button"
local Brick = require "classes.brick"


--MODULE FOR THE EDITOR BOX AND ITS COMPONENTS--

local editor_funcs = {}

local checkButtonsCollisions --Local function to check mouse or touch collision with editor_box buttons


--EDITOR BOX--

EditorBox = Class{
    __includes = {RECT},
    init = function(self)

        local x, y, w, h = 0, O_WIN_H - 200, O_WIN_W, 200
        local color = Color.blue()
        color.a = 100
        RECT.init(self, x, y, w, h, color)
        self.cur_page = 1 --Page editor box is currently in
        self.max_page = 3 --Max number of pages
        self.pages = {
            --First page
            {
                obj1 = Brick.createButton(300, y + 65, "regular_rock"),
                obj2 = Brick.createButton(650, y + 65, "tough_rock"),
                obj3 = Brick.createButton(1000, y + 65, "super_tough_rock"),

            },
            --Second page
            {
                obj1 = Brick.createButton(300, y + 65, "regular_ice"),
                obj2 = Brick.createButton(650, y + 65, "tough_ice"),
                obj3 = Brick.createButton(1000, y + 65, "super_tough_ice"),

            },
            --Third page
            {
                obj1 = Brick.createButton(300, y + 65, "regular_lava"),
                obj2 = Brick.createButton(650, y + 65, "tough_lava"),
                obj3 = Brick.createButton(1000, y + 65, "super_tough_lava"),
            },
        }

        self.change_page_button_default_color = Color.red()
        self.change_page_button_disabled_color = Color.new(0,40,100)
        self.prev_page_button = RegularButton(10, O_WIN_H - 100, 130, 80, self.change_page_button_disabled_color, "prev",
            function()
                if self.cur_page > 1 then
                    self.next_page_button.color = self.change_page_button_default_color
                    self.cur_page = self.cur_page - 1
                    if self.cur_page == 1 then
                        self.prev_page_button.color = self.change_page_button_disabled_color
                    end
                end
            end)

        self.next_page_button = RegularButton(O_WIN_W - 140, O_WIN_H - 100, 130, 80, self.change_page_button_default_color, "next",
            function()
                if self.cur_page < self.max_page then
                    self.prev_page_button.color = self.change_page_button_default_color
                    self.cur_page = self.cur_page + 1
                    if self.cur_page == self.max_page then
                        self.next_page_button.color = self.change_page_button_disabled_color
                    end
                end
            end)

        local width, height = 200, 100
        self.save_button = RegularButton(O_WIN_W - width, 0, width, height, Color.red(), "save",
            function()
                editor_funcs.save_custom_level(self)
            end

        )
        local txt
        if LEVEL_TO_LOAD then
            self.level_name = LEVEL_TO_LOAD.name
            txt = LEVEL_TO_LOAD.name
        else
            self.level_name = "no name"
            txt = "press here for a random level name"
        end



        local width, height = 1300, 100
        self.level_name_button = RegularButton(0, 0, width, height, Color.purple(), txt,
            function()
                local name = editor_funcs.getRandomName()
                self.level_name_button.text = name
                self.level_name = name
            end
        )

        self.tp = "editor_box" --Type of this class
    end
}

--CLASS FUNCTIONS-

function EditorBox:draw()

    --Draw rectangle
    Color.set(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    --Draw buttons
    self.prev_page_button:draw()
    self.next_page_button:draw()
    self.save_button:draw()
    self.level_name_button:draw()



    --Draw page objects
    for i =1, 3 do
        label = "obj"..i
        if self.pages[self.cur_page][label] then
            self.pages[self.cur_page][label]:draw()
        end
    end

    --Draw page number
    Color.set(Color.red())
    Font.set("nevis", 50)
    local text = self.cur_page.."/"..self.max_page
    love.graphics.print(text, self.pos.x + 10, self.pos.y)

    --Draw ball start position
    local c = Color.white()
    c.a = 120
    Color.set(c)
    love.graphics.circle("fill", BALL_START_POS_X, BALL_START_POS_Y, 60)
    Color.set(Color.red())
    local f = Font.set("nevis", 40)
    love.graphics.printf("ball", BALL_START_POS_X - f:getWidth("ball")/2, BALL_START_POS_Y - f:getHeight("ball")/2, 100)


end

function EditorBox:mousepressed(x, y, ...)
    for i =1, 3 do
        label = "obj"..i
        if self.pages[self.cur_page][label] then
            self.pages[self.cur_page][label]:mousepressed(x, y, ...)
        end
    end

    self:checkButtonsCollisions(x, y)

end

--Send touch presses to buttons inside
function EditorBox:touchpressed(id, x, y, ...)
    for i =1, 3 do
        label = "obj"..i
        if self.pages[self.cur_page][label] then
            self.pages[self.cur_page][label]:touchpressed(id, x, y, ...)
        end
    end

    self:checkButtonsCollisions(x, y)

end

--Iterate through all buttons inside the editor box and check for collision with (x,y) given
function EditorBox:checkButtonsCollisions(x, y)

	--Check collision with regular buttons
	buts = {self.prev_page_button, self.next_page_button, self.save_button, self.level_name_button}
	for _, but in pairs(buts) do
		if Util.pointInRect({x = x, y = y}, {x = but.pos.x, y = but.pos.y, w = but.w, h = but.h}) then
			but.func()
		end
	end
end


--UTILITY FUNCTIONS--

function editor_funcs.create()


    local b = EditorBox()
    b:addElement(DRAW_TABLE.EDITOR, nil, "editor_box")

    return b
end

function editor_funcs.save_custom_level(editor)
    local t = {
        bricks = {},
        name = editor.level_name,
        type = "custom"
    }
    local bricks = Util.findSubtype("bricks")
    if bricks then
        for brick in pairs(bricks) do
            table.insert(t.bricks, {x = brick.pos.x, y = brick.pos.y, type = brick.type})
        end
    end

    if not LEVEL_TO_LOAD then
        table.insert(CUSTOM_LEVELS, t)
    else
        for i = 1, Util.tableLen(CUSTOM_LEVELS) do
            if CUSTOM_LEVELS[i] == LEVEL_TO_LOAD then
                CUSTOM_LEVELS[i] =  t
            end
        end
    end

    Gamestate.switch(GS.MENU) --Go back to menu

end

function editor_funcs.getRandomName()

    local name
    local prefix = {"Super", "Mega", "Crazy", "Easy", "Hard"}
    local middle = {"Brick", "Firey", "Icey"}
    local pos = {"Level", "World"}

    name = Util.randomElement(prefix) .. " " .. Util.randomElement(middle) .. " " ..  Util.randomElement(pos)

    return name
end

--Return functions
return editor_funcs
