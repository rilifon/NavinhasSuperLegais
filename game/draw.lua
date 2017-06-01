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

    CAM:detach() --Stop tracking camera

    DrawTable(DRAW_TABLE.GUI)

    --Creates letterbox at the sides of the screen if needed
    FreeRes.letterbox(Color.black())

end

--Draw all the elements in a table
function DrawTable(t)

    for o in pairs(t) do
        if not o.invisible then
          love.graphics.setShader(o.shader) --Set object shader, if any
          o:draw() --Call the object respective draw function
          love.graphics.setShader() --Remove shader, if any
        end
    end

end

--Return functions
return draw
