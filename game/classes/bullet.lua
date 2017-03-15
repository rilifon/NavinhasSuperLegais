--MODULE FOR BULLETS--
local Color = require "classes.color"

local bullet = {}

--BULLET CLASS--

--_dx and _dy are normalized
Bullet = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _dx, _dy, _r, _c)
        local r, color

        r = _r --Radius of bullet
        color = _c or Color.blue()--Color of bullet

        CIRC.init(self, _x, _y, r, color, "fill") --Set atributes

        self.speedv = 700 --Speed value
        self.speed = Vector(_dx*self.speedv or 0, _dy*self.speedv or 0) --Speed vector

        self.tp = "bullet" --Type of this class
    end
}

--CLASS FUNCTIONS--

function Bullet:kill()
    local important

    if self.death then return end
    self.death = true

end

function Bullet:update(dt)
    local b

    b = self

    b.pos = b.pos + dt*b.speed

    if not b.death and
       (b.pos.x - b.r > WIN_W or
       b.pos.x + b.r < 0 or
       b.pos.y - b.r > WIN_H or
       b.pos.y + b.r < 0) then
           b:kill()
    end
end

--UTILITY FUNCTIONS--

--Create a bullet in the (x,y) position, direction dir, color c and subtype st
function bullet.create(x, y, dir, r, c, st)

    st = st or "player_bullet"

    local bullet = Bullet(x, y, dir.x, dir.y, r, c)
    bullet:addElement(DRAW_TABLE.L1, st)

    return bullet
end

--Return functions
return bullet
