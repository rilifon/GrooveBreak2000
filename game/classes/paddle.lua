--FILE FOR THE PADDLE OBJECT (A.K.A THE PLAYER)--

local paddle_funcs = {}

--Rectangle: is a positionable and colorful object with width and height
Paddle = Class{
    __includes = {RECT},
    init = function(self)
        local start_pos = Vector(100, O_WIN_H - 300)
        local width, height = 100, 80
        RECT.init(self, start_pos.x, start_pos.y, width, height, Color.white(), "fill")

        self.tp = "paddle"
    end,
}

function Paddle:touchpressed(id, x, y, dx, dy, pressure)

    self.x = x

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Create a paddle
function paddle_funcs.create(id)

    local p = Paddle()
    p:addElement(DRAW_TABLE.L3, nil, id)

    return p
end

--Return functions
return paddle_funcs
