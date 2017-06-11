--LIFE INDICATOR CLASS --

local life_ind_funcs = {}

-------------
--SIMPLE TEXT
-------------

--[[Simple Text that can print a variable]]
LifeIndicator = Class{
    __includes = {ELEMENT, POS},
    init = function(self, _x, _y)

        POS.init(self, _x, _y)

        ELEMENT.init(self)


        self.type = "normal" --What type the ball is (can be "normal", "ice" or "fire")
        self.images = {
            normal = IMG_SHOVEL,
            ice = IMG_ICE_SHOVEL,
            fire = IMG_FIRE_SHOVEL,
        }
        self.sx, self.sy = 1.5, 2
        self.image_width = 120
        self.image_height = 45
        self.quad = love.graphics.newQuad(0, 0, self.image_width, self.image_height, IMG_SHOVEL:getDimensions())

        self.paddle_lives = 0 --How many lives the paddle has


        self.tp = "life_indicator"
    end
}

--CLASS FUNCTIONS--

function LifeIndicator:update(dt)

    local p = Util.findId("player")

    --Update type of icon to match paddle's
    if p then
        self.type = p.type
        self.paddle_lives = p.lives
    else
        self.paddle_lives = 0
    end

end


function LifeIndicator:draw()
    local t

    t = self

    --Draw paddle icon
    Color.set(Color.white())
    love.graphics.draw(t.images[t.type], t.quad, t.pos.x, t.pos.y, 0, t.sx, t.sy)

    --Draw X
    Color.set(Color.red())
    local font = Font.set("nevis", 90)
    love.graphics.print("x", t.pos.x + t.image_width*t.sx + 40, t.pos.y - 20)

    --Draw lives
    Color.set(Color.purple())
    local font = Font.set("nevis", 90)
    love.graphics.print(t.paddle_lives, t.pos.x + t.image_width*t.sx + 130, t.pos.y - 25)

end

--UTILITY FUNCTIONS--

--Create a life indicator on position x, y
function life_ind_funcs.create(x, y)

    local l = LifeIndicator(x, y)
    l:addElement(DRAW_TABLE.GUI, nil, "life_indicator")

    return txt
end



--Return functions
return life_ind_funcs
