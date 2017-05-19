--MODULE FOR THE COOL SHIP--
local Bul = require "classes.bullet"

local funcs = {}
local lfuncs = {} --local functions


--SHIP CLASS--

Ship = Class{
    __includes = {ELEMENT, POS, CLR},
    init = function(self, _y)

        local x = 180 --X position of the ship on the map, that is fixed
        self.margin_distance = 80 --Minimum distance the ship can be away from the edge
        local y = _y or self.margin_distance --Y position of the ship on the map

        --Fix ship distance so it doesn't leave the screen
        y = math.max(y, self.margin_distance)
        y = math.min(y, O_WIN_H - self.margin_distance)

        ELEMENT.init(self)
        POS.init(self, x, y)
        CLR.init(self, Color.white())

        self.pulsing = false --If ship is pulsing

        self.chain_bonus = 0 --Chain bonus of hitting on the beat

        self.move_duration = .1 --Duration for ship to move to a target position


        --Creating colision values
        self.col_pos = Vector(x, y)
        self.col_r = 20

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

    --DEBUG: Print collision circle
    if DEBUG then
        Color.set(Color.blue())
        love.graphics.circle("fill", s.col_pos.x, s.col_pos.y, s.col_r)
    end

end


function Ship:update(dt)
    local s = self

    s.col_pos = Vector(s.pos.x, s.pos.y)
end

function Ship:getHit()

    --Destroy ship
    self.death = true

end

function Ship:mousepressed(x, y, button, istouch)
    local s = self --Ship

	if istouch then
		return
	end

    local w, h = FreeRes.windowDistance()
    local scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    --Move ship
    if x <= WINDOW_DIVISION and (button == 1) then
        --Fix target y value so it doesn't leave the screen
        y = math.max(y, s.margin_distance)
        y = math.min(y, O_WIN_H - s.margin_distance)
        --Start ship movement
        s:move(y)
    --Shoot a bullet
    elseif x > WINDOW_DIVISION and (button == 1) then
        s:shoot(x,y)
    end

end

function Ship:touchmoved( id, x, y, dx, dy, pressure )

    local w, h = FreeRes.windowDistance()
    local scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

    --Move ship
    if x <= WINDOW_DIVISION then
        --Fix target y value so it doesn't leave the screen
        y = math.max(y, s.margin_distance)
        y = math.min(y, O_WIN_H - s.margin_distance)
        --Start ship movement
        s:move(y)
	end
end

--Tweens ships y coordinate to given value
function Ship:move(y)
    local s = self

    if s.handles["moving"] then MAIN_TIMER:cancel(s.handles["moving"]) end
    s.handles["moving"] = MAIN_TIMER.tween(s.move_duration, s.pos, {y = y}, 'out-quad')

end

--Ship shoots a green bullet to the right, or if ship is pulsing, shoots a big bullet
function Ship:shoot(_x,_y)
	SFX_PLAYER_SHOT:play()
    local sx = self.pos.x
	local sy = self.pos.y
	local tx = _x
	local ty = _y
	
	--Defines the bullet's speed vector
	dist = math.sqrt((tx - sx)^2 + (ty - sy)^2)
	dx = (tx - sx)/dist
	dy = (ty - sx)/dist	
	
	Bul.create(s.pos.x, s.pos.y, Vector(dx,dy), Color.white(), IMG_SHOT1, "player_bullet")
end

function Ship:pulse()
    local s = self

    s.pulsing = true --Set pulsing flag

    --Remove previous tween handle on ship
    if s.handles["pulse"] then
        MAIN_TIMER.cancel(s.handles["pulse"])
    end

    --"Pulse" efect on radius
    s.handles["pulse"] = MAIN_TIMER.after(PULSE_TIME,
        function()
            s.pulsing = false
        end)


end

--LOCAL FUNCTIONS--

------------------
--USEFUL FUNCTIONS
------------------

--Create a ship in the (x,y) position
function funcs.create()
    local ship

    ship = Ship(200)
    ship:addElement(DRAW_TABLE.L2, nil, "player")

    return ship
end

--Return function for this class
return funcs
