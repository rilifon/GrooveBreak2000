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
                obj1 = Brick.createButton(300, y + 80, "regular"),
                obj2 = nil,
                obj3 = nil,

            },
            --Second page
            {
                obj1 = nil,
                obj2 = nil,
                obj3 = nil,

            },
            --Third page
            {
                obj1 = nil,
                obj2 = nil,
                obj3 = nil,
            },
        }

        self.change_page_button_default_color = Color.red()
        self.change_page_button_disabled_color = Color.new(0,40,100)
        self.prev_page_button = Button.createRegularButton(10, O_WIN_H - 100, 130, 80, self.change_page_button_disabled_color, "prev",
            function()
                if self.cur_page > 1 then
                    self.next_page_button.color = self.change_page_button_default_color
                    self.cur_page = self.cur_page - 1
                    if self.cur_page == 1 then
                        self.prev_page_button.color = self.change_page_button_disabled_color
                    end
                end
            end, nil, nil, true)

        self.next_page_button = Button.createRegularButton(O_WIN_W - 140, O_WIN_H - 100, 130, 80, self.change_page_button_default_color, "next",
            function()
                if self.cur_page < self.max_page then
                    self.prev_page_button.color = self.change_page_button_default_color
                    self.cur_page = self.cur_page + 1
                    if self.cur_page == self.max_page then
                        self.next_page_button.color = self.change_page_button_disabled_color
                    end
                end
            end, nil, nil, true)

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
    love.graphics.print(self.cur_page, self.pos.x + 10, self.pos.y)

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
	buts = {self.prev_page_button, self.next_page_button}
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

--Return functions
return editor_funcs
