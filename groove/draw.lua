--MODULE FOR DRAWING STUFF--

local draw = {}

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable object from all tables
function draw.allTables()

    DrawTable(DRAW_TABLE.BG)

    CAM:attach() --Start tracking camera

    DrawTable(DRAW_TABLE.EDITOR) --Editor box

    DrawTable(DRAW_TABLE.L0) --Particles

    DrawTable(DRAW_TABLE.L1) --Bricks

    DrawTable(DRAW_TABLE.L2) --Balls

    DrawTable(DRAW_TABLE.L3) --Paddle/Editor Box

    DrawTable(DRAW_TABLE.L4) --Name creator

    CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GUI)

end

--Draw all the elements in a table
function DrawTable(t)

    for o in pairs(t) do
        if not o.invisible then
          o:draw() --Call the object respective draw function
        end
    end

end

--Return functions
return draw
