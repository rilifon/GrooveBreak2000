--FILE FOR THE PADDLE OBJECT (A.K.A THE PLAYER)--

local ball_funcs = {}

----------------
--BALL CLASS--
----------------

Ball = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy)
        local radius = 30
        CIRC.init(self, _x, _y, radius, Color.blue())

        self.dir = Vector(_dx, _dy):normalized()
        self.speed = 1400

        self.static = true --If ball cant move

        self.can_hit_paddle = true --If ball can hit the paddle
        self.last_brick_hit = nil --Last brick ball touched. Used so ball doensn't "hit" same brick twice before hitting something else (such as wall or paddle)

        self.tp = "ball"
    end,
}

------------------
--BALL FUNCTIONS--
------------------

--UPDATE AND DRAW FUNCTIONS--

function Ball:update(dt)


    --Handle ball movement
    if not self.static then
        --Move ball
        self.pos = self.pos + self.dir*self.speed*dt


        local left_wall, right_wall, up_wall, down_wall = 0, O_WIN_W, 0, O_WIN_H
        --Check for left or right wall collision
        if self.pos.x - self.r <= left_wall or self.pos.x + self.r >= right_wall then
            self.dir.x = -self.dir.x
            self.can_hit_paddle = true
            self.last_brick_hit = nil
        end

        --Check for up wall collision
        if self.pos.y - self.r <= up_wall then
            self.dir.y = -self.dir.y
            self.can_hit_paddle = true
            self.last_brick_hit = nil
        end

        --Check for down wall collision
        if self.pos.y + self.r >= down_wall then
            self:die()
        end

        --Check collision with paddle
        local paddle = Util.findId("player")
        if paddle and  self.can_hit_paddle and Util.circInRect({x = self.pos.x, y = self.pos.y, r = self.r}, {x = paddle.pos.x, y = paddle.pos.y, w = paddle.w, h = paddle.h}) then
            self.can_hit_paddle = false
            self.last_brick_hit = nil

            --Ball is hitting the top or bottom of the paddle
            if self.pos.y <= paddle.pos.y or self.pos.y >= paddle.pos.y + paddle.h then
                --Invert y direction
                self.dir.y = -self.dir.y

                --Change x direction based on position ball hitted the pad
                self.dir.x = ((self.pos.x - paddle.pos.x)/(paddle.w))*2 - 1
                self.dir = self.dir:normalized()

            --Ball is hitting the side of the paddle
            else
                --Invert x direction
                self.dir.x = -self.dir.x
            end

        end

        --Check collision with bricks
        local all_bricks = Util.findSubtype("bricks")
        if not Util.tableEmpty(all_bricks) then
            for brick in pairs (all_bricks) do
                if not brick.death and not (brick == self.last_brick_hit) and Util.circInRect({x = self.pos.x, y = self.pos.y, r = self.r}, {x = brick.pos.x, y = brick.pos.y, w = brick.w, h = brick.h}) then
                    self.last_brick_hit = brick
                    self.can_hit_paddle = true

                    --Ball is hitting the top or bottom of the brick
                    if self.pos.y <= brick.pos.y or self.pos.y >= brick.pos.y + brick.h then
                        self.dir.y = -self.dir.y

                    --Ball is hitting the side of the paddle
                    else
                        --Invert x direction
                        self.dir.x = -self.dir.x
                    end

                    brick:got_hit(self)

                end
            end
        end


        --Invert y direction
    end

end

function Ball:draw()
    local b

    b = self

    Color.set(b.color)
    love.graphics.circle("fill", b.pos.x, b.pos.y, b.r)

end

function Ball:die()
    self.death = true
end

---------------------
--UTILITY FUNCTIONS--
---------------------

--Create a paddle
function ball_funcs.create(x, y, dx, dy, id)

    local b = Ball(x, y, dx, dy)
    b:addElement(DRAW_TABLE.L2, nil, id)

    return b
end

--Return functions
return ball_funcs
