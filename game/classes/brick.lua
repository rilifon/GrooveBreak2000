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

        self.can_drag = false --If you can drag this brick around
        self.is_being_dragged = false
        self.touch_id = nil --Id that is dragguing this brick

        self.is_button = false
        self.func = nil

        self.tp = "brick"
    end,
}

-------------------
--BRICK FUNCTIONS--
-------------------

--UPDATE AND DRAW FUNCTIONS--

function Brick:update(dt)

    --Update brick position if its being dragged
    if self.is_being_dragged then
        local x, y = love.mouse.getPosition()

        self.pos.x, self.pos.y = x - self.w/2, y - self.h/2
    end

end

function Brick:draw()
    local b = self

    Color.set(b.color)
    love.graphics.rectangle("fill", b.pos.x, b.pos.y, b.w, b.h)

end

function Brick:die()

    self.death = true

end

--MOUSE AND TOUCH FUNCTIONS--

function Brick:touchpressed(id, x, y, dx, dy, pressure)

    if self.can_drag == false or TOUCH_IS_DRAGGING_BRICK[id] then return end

    --Check if touch collides with the brick, and if so, stores the touch id for checking movement
    if Util.pointInRect({x = x, y = y}, {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}) then
        self.touchId = id
        TOUCH_IS_DRAGGING_BRICK[id] = true
    end

end

function Brick:touchreleased(id, x, y, dx, dy, pressure)

    --Check if touch released was the one controlling the brick
    if id == self.touchId then
        self.touchId = nil
        TOUCH_IS_DRAGGING_BRICK[id] = nil
    end

end

function Brick:touchmoved(id, x, y, dx, dy, pressure)

    if not self.can_drag then return end

    --If touch moving is the one controlling the brick, move the paddle
    if id == self.touchId then

        if self.handles["moving"] then MAIN_TIMER.cancel(self.handles["moving"]) end
        self.handles["moving"] = MAIN_TIMER.tween(self.move_duration, self.pos, {x = x - self.w/2}, 'out-quad')
    end

end

function Brick:mousepressed(x, y, button, isTouch)

    --Leave function if touch, because it will be handled on touchpressed function
    if isTouch or not self.can_drag or MOUSE_IS_DRAGGING_BRICK then return end

    --Check if mouse collides with the brick, and if so, brick is considered being dragged until mouse release
    if button == 1 and Util.pointInRect({x = x, y = y}, {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}) then
        self.is_being_dragged = true
        MOUSE_IS_DRAGGING_BRICK = true
    end

end

function Brick:mousereleased(x, y, button, isTouch)

    --Leave function if touch, because it will be handled on touchpressed function
    if isTouch then return end

    if button == 1 then
        self.is_being_dragged = false
        MOUSE_IS_DRAGGING_BRICK = false
    end

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

--Create a brick
function brick_funcs.create(x, y, type, st, id)

    st = st or "bricks"

    local b = Brick(x, y, type)
    b:addElement(DRAW_TABLE.L1, st, id)

    return b
end

--Create a brick that can be dragged
function brick_funcs.createDrag(x, y, type, st, id)

    st = st or "bricks"

    local b = Brick(x, y, type)
    b:addElement(DRAW_TABLE.L1, st, id)
    b.can_drag = true

    return b
end

--Create a brick that can be pressed and calls a function
function brick_funcs.createButton(x, y, type, st, id)

    st = st or "bricks_button"

    local b = Brick(x, y, type)
    b:addElement(DRAW_TABLE.L3, st, id)
    b.can_drag = true

    return b
end


--Return functions
return brick_funcs
