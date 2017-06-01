--MODULE FOR DRAWING STUFF--

local draw = {}

----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable object from all tables
function draw.allTables()

    --Makes transformations regarding screen current size
    FreeRes.transform()

    DrawTable(DRAW_TABLE.BG)

    CAM:attach() --Start tracking camera

    DrawTable(DRAW_TABLE.L1)

    DrawTable(DRAW_TABLE.L2)

    DrawTable(DRAW_TABLE.L3) --Paddle

    CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GUI)

    --Creates letterbox at the sides of the screen if needed
    FreeRes.letterbox(Color.purple())

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
