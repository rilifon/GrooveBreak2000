--FILE FOR THE PADDLE OBJECT (A.K.A THE PLAYER)--

local paddle_funcs = {}

----------------
--PADDLE CLASS--
----------------

Paddle = Class{
    __includes = {RECT},
    init = function(self)
        local width, height = 240, 50
        local start_pos = Vector(O_WIN_W/2 - width/2, O_WIN_H - 200)
        RECT.init(self, start_pos.x, start_pos.y, width, height, Color.orange())

        --Collision shape for handling touching and moving the paddle
        --Its a bit larger than the actual paddle for better player control
        self.touch_collision_shape = {}

        self.touchId = nil --The id of the touch that is controlling the paddle

        self.move_duration = .1

        self.initial_lives = 2
        self.lives = self.initial_lives --Number of lives the paddle currently has

        self.type = "normal" --What type the paddle is (can be "normal", "ice" or "fire")
        self.images = {
            normal = IMG_SHOVEL,
            ice = IMG_ICE_SHOVEL,
            fire = IMG_FIRE_SHOVEL,
        }
        self.sx, self.sy = 2, 2
        self.quads = {}
        for i = 1, 8 do
            self.quads[i] = love.graphics.newQuad(0, (i-1)*360/8, 120, 360/8, self.images[self.type]:getDimensions())
        end
        self.cur_quad = 1
        self.time_per_frames = .1
        self.handles["animation"] = MAIN_TIMER:script(
            function(wait)
                while true do
                    wait(self.time_per_frames)
                    self.cur_quad = (self.cur_quad%8) + 1
                end
            end
        )

        self.if_pressed_again_will_change_type = false
        self.time_accepted_between_touch = .4

        self.tp = "paddle"
    end,
}

--------------------
--PADDLE FUNCTIONS--
--------------------

--UPDATE AND DRAW FUNCTIONS--

function Paddle:update(dt)

    --Move paddle if its being dragged by mouse
    if self.isBeingDragged then

        local x, y = love.mouse.getPosition()
        self:move(x)

    end

    --Update collision shape for touching and related stuff
    local diff = 60 --Difference between collision shape and paddle
    self.touch_collision_shape = {
        x = self.pos.x - diff,
        y = self.pos.y - diff,
        w = self.w + 2*diff,
        h = self.h + 2*diff
    }

end

function Paddle:draw()
    local p

    p = self

    if DEBUG then
        Color.set(Color.red())
        local t = self.touch_collision_shape
        love.graphics.rectangle("fill", t.x, t.y, t.w, t.h)
    end

    Color.set(Color.white())
    love.graphics.draw(p.images[p.type], p.quads[p.cur_quad], p.pos.x, p.pos.y, 0, p.sx, p.sy)

end

--TOUCH AND MOUSE FUNCTIONS--

function Paddle:touchpressed(id, x, y, dx, dy, pressure)

    --Check for double click so the paddle will change type
    if not self.if_pressed_again_will_change_type then
        self.if_pressed_again_will_change_type = true
        if self.handles["double_click"] then MAIN_TIMER:cancel(self.handles["double_click"]) end
        self.handles["double_click"] = MAIN_TIMER:after(self.time_accepted_between_touch, function() self.if_pressed_again_will_change_type = false end)
    else
        self:changeType()
    end

    --Check if touch collides with the paddle, and if so, stores the touch id for checking movement
    if Util.pointInRect({x = x, y = y}, self.touch_collision_shape) then
        self.touchId = id
    end

end

function Paddle:touchreleased(id, x, y, dx, dy, pressure)

    --Check if touch released was the one controlling the paddle
    if id == self.touchId then
        self.touchId = nil
    end

end

function Paddle:touchmoved(id, x, y, dx, dy, pressure)

    --If touch moving is the one controlling the paddle, move the paddle
    if id == self.touchId then
        self:move(x)
    end

end

function Paddle:mousepressed(x, y, button, isTouch)

    --Leave function if touch, because it will be handled on touchpressed function
    if isTouch then return end

    --Check for double click so the paddle will change type
    if not self.if_pressed_again_will_change_type then
        self.if_pressed_again_will_change_type = true
        if self.handles["double_click"] then MAIN_TIMER:cancel(self.handles["double_click"]) end
        self.handles["double_click"] = MAIN_TIMER:after(self.time_accepted_between_touch, function() self.if_pressed_again_will_change_type = false end)
    else
        self:changeType()
    end

    --Check if mouse collides with the paddle, and if so, paddle is considered being dragged until mouse release
    if button == 1 and Util.pointInRect({x = x, y = y}, self.touch_collision_shape) then
        self.isBeingDragged = true
    end

end

function Paddle:mousereleased(x, y, button, isTouch)

    --Leave function if touch, because it will be handled on touchpressed function
    if isTouch then return end

    if button == 1 then
        self.isBeingDragged = false
    end

end

--GAME FUNCTIONS--

--Tweens paddle center x coordinate to given value
function Paddle:move(x)
    local p = self

    if p.handles["moving"] then MAIN_TIMER:cancel(p.handles["moving"]) end
    p.handles["moving"] = MAIN_TIMER:tween(p.move_duration, p.pos, {x = x - p.w/2}, 'out-quad')

end

function Paddle:changeType()

    local p = self
    SFX_CHANGE_TYPE:play()
    if p.type == "normal" then
        if love.math.random() >.5 then
            p.type =  "ice"
            SFX_FIRE_PERC:pause()
            SFX_ICE_PERC:play()
        else
            p.type = "fire"
            SFX_FIRE_PERC:play()
            SFX_ICE_PERC:pause()
        end
    elseif p.type == "fire" then
        p.type = "ice"
        SFX_FIRE_PERC:pause()
        SFX_ICE_PERC:play()
    elseif p.type == "ice" then
        p.type = "fire"
        SFX_FIRE_PERC:play()
        SFX_ICE_PERC:pause()
    end

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
