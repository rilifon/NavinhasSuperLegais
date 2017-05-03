--MODULE FOR BULLETS--

local bullet = {}

--BULLET CLASS--

--_dx and _dy are normalized
Bullet = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _x, _y, _dx, _dy, _c, _image)
        local color

        color = _c or Color.blue()--Color of bullet

        ELEMENT.init(self)
        POS.init(self, _x, _y) --Set atributes
        CLR.init(self, color)

        self.image = _image
        self.w, self.h = self.image:getDimensions()

        self.speedv = 400 --Speed value
        self.speed = Vector(_dx*self.speedv or 0, _dy*self.speedv or 0) --Speed vector

        self.col_r = 5
        if self.speed.x <= 0 then
            self.col_pos = Vector(self.pos.x, self.pos.y)
        else
            self.col_pos = Vector(self.pos.x, self.pos.y)
        end


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

    --Draw bullet image
    love.graphics.draw(IMG_SHOT1, b.pos.x - invert*w/2, b.pos.y - invert*h/2, 0, invert)

    --DEBUG: Print collision circle
    if DEBUG then
        Color.set(Color.blue())
        love.graphics.circle("fill", b.col_pos.x, b.col_pos.y, b.col_r)
    end

end

function Bullet:update(dt)
    local b

    b = self

    b.pos = b.pos + dt*b.speed

    --Update collision shape
    if self.speed.x <= 0 then
        self.col_pos = Vector(self.pos.x, self.pos.y)
    else
        self.col_pos = Vector(self.pos.x, self.pos.y)
    end

    if not b.death and
       (b.pos.x > O_WIN_W or
        b.pos.x + b.w  < 0 or
        b.pos.y > O_WIN_H or
        b.pos.y + b.h < 0) then
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
    local dx = bul.col_pos.x - target.col_pos.x
    local dy = bul.col_pos.y - target.col_pos.y
    local dr = bul.col_r + target.col_r

    return (dx*dx + dy*dy) < dr*dr
end


--UTILITY FUNCTIONS--

--Create a bullet in the (x,y) position, direction dir, color c and subtype st
function bullet.create(x, y, dir, c, image, st)

    st = st or "player_bullet"

    local bullet = Bullet(x, y, dir.x, dir.y, c, image)
    bullet:addElement(DRAW_TABLE.L1, st)

    return bullet
end

--Return functions
return bullet
