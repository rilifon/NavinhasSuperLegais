--MODULE FOR THE COOL SHIP--
local Color = require "classes.color"
local Bul = require "classes.bullet"

local funcs = {}
local lfuncs = {} --local functions


--SHIP CLASS--

Ship = Class{
    __includes = {CIRC},
    init = function(self, _y)

        self.default_r = 30 --Default radius size of ship
        self.pulse_r = 20 --Radius when ship is pulsing
        self.pulsing = false --If ship is pulsing

        self.margin_distance = 80 --Minimum distance the ship can be away from the edge

        self.chain_bonus = 0 --Chain bonus of hitting on the beat

        self.move_duration = .1 --Duration for ship to move to a target position

        local x = 180 --X position of the ship on the map, that is fixed
        local y = _y or self.margin_distance --Y position of the ship on the map
        --Fix ship distance so it doesn't leave the screen
        y = math.max(y, self.margin_distance)
        y = math.min(y, WIN_H - self.margin_distance)

        --Creating circle shape
        CIRC.init(self, x, y, self.default_r, Color.purple())

        self.type = "ship"
    end
}

--Draws the ship
function Ship:draw()
    local s

    s = self

    --Draw player
    local w, h = IMG_PLAYER:getDimensions()
    Color.set(Color.white())
    love.graphics.draw(IMG_PLAYER, s.pos.x - w/2, s.pos.y - h/2)

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
        --Fix target y value so it doesn't leave the screen
        y = math.max(y, s.margin_distance)
        y = math.min(y, WIN_H - s.margin_distance)
        --Start ship movement
        s:move(y)
    --Shoot a bullet
    elseif x > WINDOW_DIVISION and (button == 1 or istouch) then
        s:shoot()
    end

end

--Tweens ships y coordinate to given value
function Ship:move(y)
    local s = self

    if s.handles["moving"] then MAIN_TIMER:cancel(s.handles["moving"]) end
    s.handles["moving"] = MAIN_TIMER.tween(s.move_duration, s.pos, {y = y}, 'out-quad')

end

--Ship shoots a green bullet to the right, or if ship is pulsing, shoots a big bullet
function Ship:shoot()
  SFX_PLAYER_SHOT:play()
    local s = self
    local max = 20 --Max size for bullets

    if not s.pulsing then
        s.chain_bonus = 0
        Bul.create(s.pos.x + s.r, s.pos.y, Vector(1,0), 5, Color.white(), "player_bullet")
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
