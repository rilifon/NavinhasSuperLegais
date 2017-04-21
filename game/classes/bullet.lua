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

function Bullet:draw()
    local b = self

    --Draw bullet
    local w, h = IMG_SHOT1:getDimensions()
    Color.set(b.color)
    --Check direction of bullet in case you need to invert the sprite
    local invert
    if b.speed.x <= 0 then
        invert = -1
    else
        invert = 1
    end

    love.graphics.draw(IMG_SHOT1, b.pos.x - w/2, b.pos.y - h/2, 0, invert)

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

--When an enemy bullet hits the player, destroy the bullet
function Bullet:hitPlayer()

    --Destroy bullet
    self.death = true

end

--When a player bullet hits an enemy, destroy the bullet
function Bullet:hitEnemy()

    --Destroy bullet
    self.death = true

end

--Check collision of bullet with something
function Bullet:collides(target)
    local bul = self
    local dx = bul.pos.x - target.pos.x
    local dy = bul.pos.y - target.pos.y
    local dr = bul.r + target.r

    return (dx*dx + dy*dy) < dr*dr
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
