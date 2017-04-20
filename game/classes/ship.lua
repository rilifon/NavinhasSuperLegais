--MODULE FOR THE COOL SHIP--
local Color = require "classes.color"
local Bul = require "classes.bullet"

local funcs = {}
local lfuncs = {} --local functions


--SHIP CLASS--

Ship = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)

        self.default_r = 30 --Default radius size of ship
        self.pulse_r = 20 --Radius when ship is pulsing
        self.pulsing = false --If ship is pulsing

        self.chain_bonus = 0 --Chain bonus of hitting on the beat

        local x = _x or 50 --X position of the ship on the map
        local y = _y or 50 --Y position of the ship on the map

        --Creating circle shape
        CIRC.init(self, x, y, self.default_r, Color.purple())

        self.type = "ship"
    end
}

--Draws the ship
function Ship:draw()
    local s

    s = self

    --Draw circle
    Color.set(s.color)
    love.graphics.circle("fill", s.pos.x, s.pos.y, s.r)

    --Draw outline
    love.graphics.setLineWidth(4)
    local color = s.color
    Color.set(s.color)
    love.graphics.circle("line", s.pos.x, s.pos.y, s.r)


end


function Ship:update(dt)
    local s = self

end

function Ship:getHit()

    --Destroy ship
    self.death = true

end

function Ship:keypressed(key)
    local s = self --Ship

    --Shoot a bullet
    if key == "z" or key == "space" then
        s:shoot()
    end

end

function Ship:mousepressed(x, y, button, istouch)
    local s = self --Ship

    --Move ship
    if x <= WINDOW_DIVISION and (button == 1 or istouch) then
        s.pos.x, s.pos.y = x, y
    --Shoot a bullet
    elseif x > WINDOW_DIVISION and (button == 1 or istouch) then
        s:shoot()
    end

end

--Ship shoots a green bullet to the right, or if ship is pulsing, shoots a big bullet
function Ship:shoot()
  SFX_PLAYER_SHOT:play()
    local s = self
    local max = 20 --Max size for bullets

    if not s.pulsing then
        s.chain_bonus = 0
        Bul.create(s.pos.x + s.r, s.pos.y, Vector(1,0), 5, Color.black(), "player_bullet")
    else
        s.chain_bonus = s.chain_bonus + 1 --Increment chain
        local size = math.min(5+3*s.chain_bonus, max) --Cap for bullet size

        --If bullet is at cap, change bullet color
        local c
        if size >= max then
            c = Color.red()
        else
            c = Color.blue()
        end

        Bul.create(s.pos.x + s.r, s.pos.y, Vector(1,0), size, c)
    end

end

function Ship:pulse()
    local s = self

    s.pulsing = true --Set pulsing flag

    --Remove previous tween handle on ship
    if s.handles["pulse"] then
        MAIN_TIMER.cancel(s.handles["pulse"])
    end

    --"Pulse" efect on radius
    s.handles["pulse"] = MAIN_TIMER.tween(PULSE_TIME/2, s, {r = s.pulse_r}, 'in-linear',
        function()
            s.handles["pulse"] = MAIN_TIMER.tween(PULSE_TIME/2, s, {r = s.default_r}, 'in-linear',
            function()
                s.pulsing = false
            end)

        end)


end

--LOCAL FUNCTIONS--

------------------
--USEFUL FUNCTIONS
------------------

--Create a ship in the (x,y) position
function funcs.create(x, y)
    local ship

    ship = Ship(x, y)
    ship:addElement(DRAW_TABLE.L2, nil, "player")

    return ship
end

--Return function for this class
return funcs
