--FILE FOR THE BRICK OBJECT (A.K.A THE DIFFICULTIES IN OUR DAILY LIVES)--

local brick_funcs = {}

---------------
--BRICK CLASS--
---------------

Brick = Class{
    __includes = {RECT},
    init = function(self, _x, _y, _type)
        local width, height, color, hits_to_break

        self.type = _type

        --ICE BLOCKS
        if _type == "regular_ice" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(0,0,255)
            hits_to_break = 1
            image = IMG_ICE_BLOCK
            quads = {}
            hit_sound = SFX_ICE_BRICK_HIT
            break_sound = SFX_ICE_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        elseif _type == "tough_ice" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(90,120,185)
            hits_to_break = 2
            image = IMG_ICE_BLOCK
            quads = {}
            hit_sound = SFX_ICE_BRICK_HIT
            break_sound = SFX_ICE_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        elseif _type == "super_tough_ice" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(160,130,185)
            hits_to_break = 3
            image = IMG_ICE_BLOCK
            quads = {}
            hit_sound = SFX_ICE_BRICK_HIT
            break_sound = SFX_ICE_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        --LAVA BLOCKS
        elseif _type == "regular_lava" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(0,0,255)
            hits_to_break = 1
            image = IMG_LAVA_BLOCK
            quads = {}
            hit_sound = SFX_FIRE_BRICK_HIT
            break_sound = SFX_FIRE_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        elseif _type == "tough_lava" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(90,120,185)
            hits_to_break = 2
            image = IMG_LAVA_BLOCK
            quads = {}
            hit_sound = SFX_FIRE_BRICK_HIT
            break_sound = SFX_FIRE_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        elseif _type == "super_tough_lava" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(180,30,125)
            hits_to_break = 3
            image = IMG_LAVA_BLOCK
            quads = {}
            hit_sound = SFX_FIRE_BRICK_HIT
            break_sound = SFX_FIRE_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        --ROCK BLOCKS
    elseif _type == "regular_rock" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(0,0,255)
            hits_to_break = 1
            image = IMG_ROCK_BLOCK
            quads = {}
            hit_sound = SFX_ROCK_BRICK_HIT
            break_sound = SFX_ROCK_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        elseif _type == "tough_rock" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(90,120,185)
            hits_to_break = 2
            image = IMG_ROCK_BLOCK
            quads = {}
            hit_sound = SFX_ROCK_BRICK_HIT
            break_sound = SFX_ROCK_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        elseif _type == "super_tough_rock" then
            sx = 1.5
            sy = 1.5
            width = 180
            height = 75
            color = Color.new(160,130,185)
            hits_to_break = 3
            image = IMG_ROCK_BLOCK
            quads = {}
            hit_sound = SFX_ROCK_BRICK_HIT
            break_sound = SFX_ROCK_BRICK_BREAK
            for i = 1, 5 do
                quads[i] = love.graphics.newQuad(0, (i-1)*height/sy, width/sx, height/sy, image:getDimensions())
            end
        end
        RECT.init(self, _x, _y, width, height, color)

        self.hits_to_break = hits_to_break --How many hits the block needs to break
        self.is_destroyed = false --If the block is being destroyed

        self.hit_sound = hit_sound
        self.break_sound = break_sound

        self.image = image
        self.quads = quads
        self.cur_quad = 1 --Current quad to draw
        self.sx = 1.5 --X scaling of the image
        self.sy = 1.5 --Y scaling of the image


        self.can_drag = false --If you can drag this brick around
        self.is_being_dragged = false
        self.touch_id = nil --Id that is dragguing this brick

        self.move_duration = .1

        self.is_button = false

        self.tp = "brick"
    end,
}

-------------------
--BRICK FUNCTIONS--
-------------------

--UPDATE AND DRAW FUNCTIONS--

function Brick:update(dt)

    if self.is_button then return end

    --Update brick position if its being dragged
    if self.is_being_dragged then
        local x, y = love.mouse.getPosition()

        self.pos.x, self.pos.y = x - self.w/2, y - self.h/2
    end

end

function Brick:draw()
    local b = self

    Color.set(self.color)
    love.graphics.draw(self.image, self.quads[self.cur_quad], b.pos.x, b.pos.y, 0, self.sx, self.sy)

end

--Create animation of brick being destroyed before removing it
function Brick:die()

    self.death = true

    local color
    if self.type == "regular_ice" or self.type == "tough_ice" or  self.type == "super_tough_ice" then
        color = Color.new(140,200,225)
    elseif self.type == "regular_lava" or self.type == "tough_lava" or  self.type == "super_tough_lava" then
        color = Color.new(0,150,125)
    elseif self.type == "regular_rock" or self.type == "tough_rock" or  self.type == "super_tough_rock" then
        color = Color.new(39, 33, 117)
    end

    FX.explosion(self.pos.x + self.w/2, self.pos.y + self.h/2, color)
end

--MOUSE AND TOUCH FUNCTIONS--

function Brick:touchpressed(id, x, y, dx, dy, pressure)

    if self.is_button then
        --Check if touch collides with a brick button, generate a copy to drag
        if Util.pointInRect({x = x, y = y}, {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}) then
            self:generateBrickTouch(id)
        end
    else
        if self.can_drag == false or TOUCH_IS_DRAGGING_BRICK[id] then return end

        --Check if touch collides with the brick, and if so, stores the touch id for checking movement
        if Util.pointInRect({x = x, y = y}, {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}) then
            self.touchId = id
            TOUCH_IS_DRAGGING_BRICK[id] = true
        end

    end

end

function Brick:touchreleased(id, x, y, dx, dy, pressure)

    if self.is_button then return end

    --Check if touch released was the one controlling the brick
    if id == self.touchId then
        self.touchId = nil
        TOUCH_IS_DRAGGING_BRICK[id] = nil
    end

end

function Brick:touchmoved(id, x, y, dx, dy, pressure)

    if not self.can_drag or self.is_button or not TOUCH_IS_DRAGGING_BRICK[id] then return end

    --If touch moving is the one controlling the brick, move the paddle
    if id == self.touchId then

        if self.handles["moving"] then MAIN_TIMER:cancel(self.handles["moving"]) end
        self.handles["moving"] = MAIN_TIMER:tween(self.move_duration, self.pos, {x = x - self.w/2, y = y - self.w/2}, 'out-quad')

    end

end

function Brick:mousepressed(x, y, button, isTouch)

    if isTouch then return end

    --Check if mouse collides with a brick button
    if self.is_button and button == 1 and Util.pointInRect({x = x, y = y}, {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}) then
        self:generateBrickMouse()
    else
        --Leave function if touch, because it will be handled on touchpressed function
        if isTouch or not self.can_drag or MOUSE_IS_DRAGGING_BRICK then return end

        --Check if mouse collides with the brick, and if so, brick is considered being dragged until mouse release
        if button == 1 and Util.pointInRect({x = x, y = y}, {x = self.pos.x, y = self.pos.y, w = self.w, h = self.h}) then
            self.is_being_dragged = true
            MOUSE_IS_DRAGGING_BRICK = true
        end
    end

end

function Brick:mousereleased(x, y, button, isTouch)

    --Leave function if touch, because it will be handled on touchpressed function
    if isTouch or self.is_button then return end

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
        self.break_sound:play()
        self:die()
    else
        self.hit_sound:play()
        self.cur_quad = self.cur_quad + 2
    end

end

--Function called when the brick is a button and is pressed by a mouse.
--It will create a draggable button of the same type, and the player will already be dragging it around
function Brick:generateBrickMouse()

    local b = brick_funcs.createDrag(self.pos.x, self.pos.y, self.type)
    b.is_being_dragged = true
    MOUSE_IS_DRAGGING_BRICK = true

end

--Function called when the brick is a button and is touched.
--It will create a draggable button of the same type, and the player will already be dragging it around
function Brick:generateBrickTouch(id)

    local b = brick_funcs.createDrag(self.pos.x, self.pos.y, self.type)
    b.touchId = id
    TOUCH_IS_DRAGGING_BRICK[id] = true

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

--Create a brick that can be pressed to generate a draggable brick of the same type
function brick_funcs.createButton(x, y, type)

    local b = Brick(x, y, type)
    b.is_button = true

    return b
end

--Return functions
return brick_funcs
