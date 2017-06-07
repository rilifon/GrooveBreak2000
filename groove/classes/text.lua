--TEXT CLASS --

local text = {}

-------------
--SIMPLE TEXT
-------------

--[[Simple Text that can print a variable]]
Text = Class{
    __includes = {ELEMENT, WTXT, POS},
    init = function(self, _x, _y, _text, _font_name, _font_size, _color)

        self.text = _text
        self.font_name = _font_name
        self.font_size = _font_size
        self.color = _color or Color.purple()

        POS.init(self, _x, _y)

        ELEMENT.init(self)

        self.tp = "text"
    end
}


function Text:draw()
    local t, text, color

    t = self

    --Draws button text
    Color.set(self.color)
    Font.set(t.font_name, t.font_size)
    love.graphics.print(t.text, t.pos.x, t.pos.y)

end

--UTILITY FUNCTIONS--

--Create a regular text
function text.create(x, y, text, font_name, font_size, color, st, id, draw_table)

    draw_table = draw_table or "GUI"
    local txt = Text(x, y, text, font_name, font_size, color)
    txt:addElement(DRAW_TABLE[draw_table], st, id)

    return txt
end



--Return functions
return text
