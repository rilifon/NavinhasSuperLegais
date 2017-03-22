--MODULE FOR THE COOL SHIP--
local Color = require "classes.color"
local Bul = require "classes.bullet"

local funcs = {}
local lfuncs = {} --local functions


--SHIP CLASS--

Ship = Class{
    __includes = {CIRC},
    init = function(self, _x, _y)

        self.default_r = TILESIZE/3 --Default radius size of ship
        self.pulse_r = TILESIZE/4 --Radius when ship is pulsing
        self.pulsing = false --If ship is pulsing

        self.chain_bonus = 0 --Chain bonus of hitting on the beat

        self.grid_x = _x or 1
        self.grid_y = _y or 1

        local x = (self.grid_x-1)*TILESIZE + TILESIZE/2
        local start_grid = (WIN_H - GRID_ROWS*TILESIZE)/2 --Start y position of grid on map
        local y = start_grid + (self.grid_y-1)*TILESIZE + TILESIZE/2

        --Creating circle shape
        CIRC.init(self, x, y, self.default_r, Color.purple())

        self.type = "Ship"
    end
}


function Ship:update(dt)
    local s = self

end

function Ship:keypressed(key)
    local s = self --Ship

    --Movement
    if s.pulsing then
        if key == 'w' or key == 'up' then
            if s.grid_y > 1 then
                s.grid_y = s.grid_y - 1
                s.pos.y = s.pos.y - TILESIZE
            end
        elseif key == 'd' or key == 'right' then
            if s.grid_x <  GRID_COLS then
                s.grid_x = s.grid_x + 1
                s.pos.x = s.pos.x + TILESIZE
            end
        elseif key == 's' or key == 'down' then
            if s.grid_y <  GRID_ROWS then
                s.grid_y = s.grid_y + 1
                s.pos.y = s.pos.y + TILESIZE
            end
        elseif key == 'a' or key == 'left' then
            if s.grid_x > 1 then
                s.grid_x = s.grid_x - 1
                s.pos.x = s.pos.x - TILESIZE
            end
        end
    end

    if key == "z" or key == "space" then
        s:shoot()
    end

end

--Ship shoots a green bullet to the right, or if ship is pulsing, shoots a big bullet
function Ship:shoot()
    local s = self
    local max = 20 --Max size for bullets

    if not s.pulsing then
        s.chain_bonus = 0
        Bul.create(s.pos.x + s.r, s.pos.y, Vector(1,0), 5, Color.green())
    else
        s.chain_bonus = s.chain_bonus + 1 --Increment chain
        local size = math.min(5+3*s.chain_bonus, max) --Cap for bullet size

        --If bullet is at cap, change bullet color
        if size >= max then
            local c = Color.red()
        else
            local c = Color.blue()
        end

        Bul.create(s.pos.x + s.r, s.pos.y, Vector(1,0), 5+2*s.chain_bonus, c)
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
