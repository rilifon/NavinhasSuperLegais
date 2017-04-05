local Util = require "util"
local Draw = require "draw"
local Ship = require "classes.ship"
local Enemy = require "classes.enemy"
local Background = require "classes.background"
local Bgm = require "classes.bgm"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}

--LOCAL VARIABLES--

local pulsed --If ship already pulsed

--LOCAL FUNCTIONS--

local checkCollisions

--STATE FUNCTIONS--

function state:enter()

	--Initialize variables for the game
	pulsed = false
	BPM_C = 0
	MUSIC_BEAT = 0

	Bgm.create(BGM_MAIN, 2) --Create background music object with start time

	Background.create() --Create background and grid


	Ship.create(2,1) --Create ship

	--Create enemies
	Enemy.create(15,1,1,20,{2,3,4,5,10,12,14,16,20,21})
	--Enemy.create(15,2,2,20,{6,7,8,9,11,13,15,17,20,21})
	--Enemy.create(13,3,0,22,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17})


end

function state:leave()

end


function state:update(dt)
	local s = Util.findId("player")

	--Update bmp counter
	BPM_C = BPM_C + dt
	if BPM_C >= (60/BPM_M - PULSE_TIME/2) and not pulsed then
		--Reached "pulse" time
		pulsed = true

		if s then s:pulse() end

	elseif BPM_C >= 60/BPM_M and pulsed then
		--Reached beat time
		BPM_C = BPM_C - 60/BPM_M

		pulsed = false
	end

	--Update music beat tracker
	MUSIC_BEAT = MUSIC_BEAT + (dt*BPM_M/60)

	Util.updateDrawTable(dt)

	Util.updateId(dt, "cur_bgm")

	Util.updateTimers(dt)

	checkCollisions()

	Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)
	local s = Util.findId("player")

	if s then s:keypressed(key) end --Handles keypressing for player
    Util.defaultKeyPressed(key)    --Handles keypressing for general stuff

end

--LOCAL FUNCTIONS

function checkCollisions()

	--Check collision between enemy bullets and the ship
	local s = Util.findId("player")
	local enemy_b = Util.findSbTp("enemy_bullet")
	if enemy_b and s then
		for bullet in pairs(enemy_b) do
			if bullet:collides(s) then
				s:getHit()
				bullet:hitPlayer()
			end
		end
	end

	--Check collision between player bullets and enemies
	local enemies = Util.findSbTp("enemies")
	local player_b = Util.findSbTp("player_bullet")
	if player_b and enemies then
		for bullet in pairs(player_b) do
			for enemy in pairs(enemies) do
				if bullet:collides(enemy) then
					enemy:getHit()
					bullet:hitEnemy()
				end
			end
		end
	end

end

--Return state functions
return state
