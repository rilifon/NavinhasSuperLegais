--MODULE FOR THE COOL SHIP--
local Color = require "classes.color"
local Bul = require "classes.bullet"

local funcs = {}

--ENEMY CLASS--
--[[Has a time to enter and leave screen, and a shoot pattern. The shoot pattern must be in crescent order]]
Enemy = Class{
    __includes = {CIRC},
    init = function(self, _x, _y, _enter_time, _leave_time,_shoot_pattern)

        self.enter_time = _enter_time --Which beat the enemy enters the screen
        self.entered = false --If enemy has entered the screen
        self.leave_time = _leave_time --Which beat the enemy leaves the screen
        self.leaved = false --If enemy is leaving the screen

        self.shoot_pattern = _shoot_pattern or {} --Which beats the enemy shoots
        self.shoot_indicator = 1 --Indicates which part of the shoot_pattern the enemy is

		local radius = 50

        --Creating circle shape
        CIRC.init(self, _x, _y, 40, Color.red())

        self.type = "enemy"
    end
}


function Enemy:update(dt)
    local s = self

    --Checks if enemy has entered the screen
    if not s.entered and MUSIC_BEAT >= s.enter_time then
        s.entered = true
    end

    --Checks if enemy has to shoot
    if  s.entered and
        s.shoot_indicator <= Util.tableLen(s.shoot_pattern) and
        MUSIC_BEAT >= s.shoot_pattern[s.shoot_indicator] then
            s.shoot_indicator = s.shoot_indicator + 1
            s:shoot()
    end

    --checks if enemy must leave the screen
    if not s.leaved and MUSIC_BEAT >= s.leave_time then
        s.leaved = true
        s:leave()
    end
end

function Enemy:draw()
    local s = self

    if not s.entered then return end

    --Draw the enemy
    Color.set(s.color)
    love.graphics.circle(s.mode, s.pos.x, s.pos.y, s.r)

end

function Enemy:leave()
    print "enemy is kill"
    self.death = true
end


--Enemy shoots bullet to the left
function Enemy:shoot()
    SFX_ENEMY_SHOT:play()
    local s = self
    local b = Bul.create(s.pos.x + s.r, s.pos.y, Vector(-1,0), 5, Color.black(), "enemy_bullet")

end

--If enemy gets hit, destroy him
function Enemy:getHit()

    --Play sfx
    SFX_HITENEMY:play()

    --Destroy enemy
    self.death = true

end

------------------
--USEFUL FUNCTIONS
------------------

--Create an enemy in the (x,y) position on the grid, with a shooting_pattern and an optional id
function funcs.create(x, y, enter_time, leave_time, shoot_pattern, id)
    local enemy

    enemy = Enemy(x, y, enter_time, leave_time, shoot_pattern)
    enemy:addElement(DRAW_TABLE.L2, "enemies", id)

    return enemy
end

--Return functions for this class
return funcs
