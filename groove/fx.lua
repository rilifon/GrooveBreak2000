local Particle = require "classes.particle"

--MODULE FOR EFFECTS AND STUFF--

local fx_funcs = {}


function fx_funcs.explosion(x, y, color, number, size, speed)

    --Default Values
    local number = number or 25  --Number of particles created in a explosion
    local size =  size or 10
    local speed  = speed or 220  --Particles speed
    local decaying = 400  --Particles decaying alpha speed (decreases this amount per second, when reaching 0, it will be deleted)


    --Creates all particles of explosion
    for i=1, number do

        --Randomize direction for each particle (value between [-1,1])
        local dir = Vector(0,0)
        dir.x = love.math.random()*2 - 1
        dir.y = love.math.random()*2 - 1
        local r = 20
        --Randomize position inside a circle of radius 20
        local angle = 2*math.pi*love.math.random()
        local radius = 2*r*love.math.random()
        if radius > r then
            radius = 2*r-radius
        end
        local pos = Vector(0,0)
        pos.x = x + radius*math.cos(angle)
        pos.y = y + radius*math.sin(angle)

        Particle.create_decaying(pos, dir, color, speed * (1 - love.math.random()*.5), decaying, size)

    end
end

--Return functions
return fx_funcs
