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

	Bgm.create(TRACKS.MAIN, 2, "cur_bgm") --Create background music object with start time
	Bgm.create(SFX.AMBIENCE, 0, "ambience_sfx")

	Background.create() --Create background

	Ship.create() --Create ship

	--Create enemies
	--(x, y, enter_time, leave_time, shoot_pattern, target_pattern, id)
	Enemy.create(2138.85, 436.8, 3, 40, {2,3,4,5,6}, {10,30})

end

function state:leave()

	Util.destroyAll("force")

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
	Util.updateId(dt, "ambience_sfx")

	Util.updateTimers(dt)

	checkCollisions()


	Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)
	local s = Util.findId("player")

    Util.defaultKeyPressed(key)    --Handles keypressing for general stuff

end

function state:mousepressed(x, y, button, istouch)
	if istouch then
		return
	end

	local s = Util.findId("player")

	if s then
		s:mousepressed(x, y, button, istouch)
	end
    state:touchpressed(nil, x, y)
end

function state:touchpressed(id, x, y, dx, dy, pressure)
	local s = Util.findId("player")

	if not s then return end --leave function if player doesnt exist

	if s then s:touchpressed(id, x, y, dx, dy, pressure) end --Handles touch for player

	--Check touch collision with all enemies
	local enemies = Util.findSbTp("enemies")
	if enemies then
		for enemy in pairs(enemies) do
			--Check collision between enemy and circle of radius 1 (a point) where user touched
			if enemy:collides({col_pos = Vector(x,y), col_r = 5}) then
				if enemy:canBeShot() then
					print(enemy.col_pos.x, enemy.col_pos.y)
					s:shoot(enemy.col_pos.x, enemy.col_pos.y)
					enemy.was_shot = true
				end
			end
		end
	end

end

function state:touchmoved(...)
	local s = Util.findId("player")

	if s then s:touchmoved(...) end --Handles moving touch for player
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
