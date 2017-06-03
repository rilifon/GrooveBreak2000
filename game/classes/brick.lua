--FILE FOR THE BRICK OBJECT (A.K.A THE DIFFICULTIES IN OUR DAILY LIVES)--

local brick_funcs = {}

---------------
--BRICK CLASS--
---------------

Brick = Class{
    __includes = {RECT},
    init = function(self, _x, _y, _type)
        local width, height, color, hits_to_break

        if _type == "regular" then
            width = 170
            height = 60
            color = Color.red()
            hits_to_break = 1
        end
        RECT.init(self, _x, _y, width, height, color)

        self.hits_to_break = hits_to_break

        self.tp = "brick"
    end,
}

-------------------
--BRICK FUNCTIONS--
-------------------

--UPDATE AND DRAW FUNCTIONS--

function Brick:update(dt)



end

function Brick:draw()
    local b = self

    Color.set(b.color)
    love.graphics.rectangle("fill", b.pos.x, b.pos.y, b.w, b.h)

end

function Brick:die()

    self.death = true

end

--GAME FUNCTIONS--

--Function called when the brick got hit by a ball. Receives the ball as argument.
function Brick:got_hit(ball)

    self.hits_to_break = self.hits_to_break - 1
    if self.hits_to_break <= 0 then
        self:die()
    end

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Create a paddle
function brick_funcs.create(x, y, type, st, id)

    st = st or "bricks"

    local b = Brick(x, y, type)
    b:addElement(DRAW_TABLE.L1, st, id)

    return b
end

--Return functions
return brick_funcs
