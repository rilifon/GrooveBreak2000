local Button = require "classes.button"

--MODULE FOR BUTTONS--

local editor_funcs = {}

--REGULAR BUTTON--

--Normal rectangular button, with a text and a function to call when pressed
EditorBox = Class{
    __includes = {RECT},
    init = function(self)

        local x, y, w, h = 0, O_WIN_H - 200, O_WIN_W, 200
        local color = Color.blue()
        color.a = 100
        RECT.init(self, x, y, w, h, color)
        self.cur_page = 1 --Page editor box is currently in
        self.max_page = 2 --Max number of pages
        self.pages = {
        }

        self.prev_page_button = Button.createRegularButton(10, O_WIN_H - 100, 130, 80, Color.red(), "prev",
            function()
                self.cur_page = math.max(self.cur_page - 1, 1)
            end)

        self.next_page_button = Button.createRegularButton(O_WIN_W - 140, O_WIN_H - 100, 130, 80, Color.red(), "next",
            function()
                self.cur_page = math.min(self.cur_page + 1, self.max_page)
            end)

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

    Color.set(Color.red())
    Font.set("nevis", 50)
    love.graphics.print(self.cur_page, self.pos.x + 10, self.pos.y)

end

--UTILITY FUNCTIONS--

function editor_funcs.create()


    local b = EditorBox()
    b:addElement(DRAW_TABLE.L3, nil, "editor_box")

    return b
end

--Return functions
return editor_funcs
