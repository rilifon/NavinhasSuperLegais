--MODULE FOR THE COOL SHIP--
local Color = require "classes.color"
local Bul = require "classes.bullet"

local funcs = {}
local lfuncs = {} --local functions


--SHIP CLASS--

Ship = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)

        self.default_r = 80 --Default radius size of ship
        self.pulse_r = 60 --Radius when ship is pulsing
        self.pulsing = false --If ship is pulsing

        self.speedv = 300 --Speed value
        self.speed  = Vector(0,0) --Speed vector

        --Creating circle shape
        CIRC.init(self, _x or 100, _y or 100, self.default_r, Color.purple())

        self.type = "Ship"
    end
}


function Ship:update(dt)
    local s = self

    --Update movement
    if not s.focused then
        s.pos = s.pos + dt*s.speed
    else
        s.pos = s.pos + dt*s.speed
    end

    --Fixes if ship leaves screen
    s.pos.x, s.pos.y = lfuncs.isOutside(s)

end

function Ship:keypressed(key)
    local s = self --Ship

    --Movement
    if key == 'w' or key == 'a' or key == 's' or key == 'd' or
       key == 'up' or key == 'left' or key == 'down' or key == 'right' then
        lfuncs.updateSpeed(s)
    elseif key == "z" or key == "space" then
        s:shoot()
    end

end

function Ship:keyreleased(key)
    local s = self --Ship

    --Movement
    if key == 'w' or key == 'a' or key == 's' or key == 'd' or
       key == 'up' or key == 'left' or key == 'down' or key == 'right' then
          lfuncs.updateSpeed(s)
    end

end

--Ship shoots a green bullet to the right, or if ship is pulsing, shoots a big bullet
function Ship:shoot()
    local s = self

    if not s.pulsing then
        Bul.create(s.pos.x + s.r, s.pos.y, Vector(1,0), 5, Color.green())
    else
        Bul.create(s.pos.x + s.r, s.pos.y, Vector(1,0), 20, Color.blue())
    end

end

function Ship:pulse()
    local s = self

    s.pulsing = true --Set pulsing flag
    s.r = s.pulse_r  --Change radius of ship

    --"Pulse" efect on radius
    local handle = MAIN_TIMER.tween(.1, s, {r = s.default_r}, 'in-linear',
        function()
            s.pulsing = false
        end)

    --Insert tween handle on ship
    if s.handles["pulse"] then
        MAIN_TIMER.cancel(s.handles["pulse"])
    end
    s.handles["pulse"] = handle


end



--LOCAL FUNCTIONS--

function lfuncs.updateSpeed(self)
    local s = self --Ship
    local sp = s.speedv --Speed Value

    s.speed = Vector(0,0)
    --Movement
    if love.keyboard.isDown 'w' or love.keyboard.isDown 'up' then --move up
        s.speed = s.speed + Vector(0,-1)
    end
    if love.keyboard.isDown 'a' or love.keyboard.isDown 'left' then --move left
        s.speed = s.speed + Vector(-1,0)
    end
    if love.keyboard.isDown 's' or love.keyboard.isDown 'down' then --move down
        s.speed = s.speed + Vector(0,1)
    end
    if love.keyboard.isDown'd' or love.keyboard.isDown 'right' then --move right
        s.speed = s.speed + Vector(1,0)
    end

    s.speed = s.speed:normalized() * sp

end

--Checks if ship has leaved the game screen (even if partially) and returns correct position
function lfuncs.isOutside(s)
    local x, y

    x, y = s.pos.x, s.pos.y

    --X position
    if s.pos.x - s.r <= 0 then
        x = s.r
    elseif s.pos.x + s.r >= WIN_W then
        x = WIN_W - s.r
    end

    --Y position
    if s.pos.y - s.r <= 0 then
        y = s.r
    elseif s.pos.y + s.r >= WIN_H then
        y = WIN_H - s.r
    end

    return x,y
end


------------------
--USEFUL FUNCTIONS
------------------

--Create a ship in the (x,y) position, direction dir, color c and subtype st
function funcs.create(x, y)
    local ship

    ship = Ship(x, y)
    ship:addElement(DRAW_TABLE.L2, nil, "player")

    return ship
end

--Return function for this class
return funcs
