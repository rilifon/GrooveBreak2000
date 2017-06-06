--MODULE FOR BUTTONS--

local button_funcs = {}

--REGULAR BUTTON--

--Normal rectangular button, with a text and a function to call when pressed
RegularButton = Class{
    __includes = {RECT},
    init = function(self, _x, _y, _w, _h, _c, _text, _func)

        RECT.init(self, _x, _y, _w, _h, _c)

        self.text = _text
        self.func = _func
        self.font_size = 50
        self.font_color = Color.black()

        self.tp = "regular_button" --Type of this class
    end
}

--CLASS FUNCTIONS-

function RegularButton:draw()

    --Draw rectangle
    Color.set(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y, self.w, self.h)

    --Draw text
    font = Font.set("nevis", self.font_size)
    Color.set(self.font_color)
    local tx = self.pos.x + self.w/2 - font:getWidth(self.text)/2
    local ty = self.pos.y + self.h/2 - font:getHeight(self.text)/2
    love.graphics.print(self.text, tx, ty)

end

--UTILITY FUNCTIONS--

function button_funcs.createRegularButton(x, y, w, h, c, text, func, st, id)

    st = st or "regular_buttons"

    local b = RegularButton(x, y, w, h, c, text, func)
    b:addElement(DRAW_TABLE.L1, st, id)

    return b
end

--Return functions
return button_funcs
