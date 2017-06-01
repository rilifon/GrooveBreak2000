--FILE FOR THE PADDLE OBJECT (A.K.A THE PLAYER)--

local ball_funcs = {}

----------------
--BALL CLASS--
----------------

Ball = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy)
        local radius = 40
        CIRC.init(self, _x, _y, radius, Color.blue())

        self.dir = Vector(_dx, _dy):normalized()
        self.speed = 700

        self.static = true

        self.tp = "ball"
    end,
}

------------------
--BALL FUNCTIONS--
------------------

--UPDATE AND DRAW FUNCTIONS--

function Ball:update(dt)

    --Move the ball
    if not self.static then
        self.pos = self.pos + self.dir*self.speed*dt
    end

end

function Ball:draw()
    local b

    b = self

    Color.set(b.color)
    love.graphics.circle("fill", b.pos.x, b.pos.y, b.r)

end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Create a paddle
function ball_funcs.create(x, y, dx, dy, id)

    local b = Ball(x, y, dx, dy)
    b:addElement(DRAW_TABLE.L2, nil, id)

    --Make ball keep static for a few seconds before moving
    b.handles["start_static"] = MAIN_TIMER.after(2, function() b.static = false end)

    return b
end

--Return functions
return ball_funcs
