local Ship = require "classes.ship"
local Enemy = require "classes.enemy"
local Background = require "classes.background"
local Bgm = require "classes.bgm"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}

--LOCAL VARIABLES--

local level = {} --saves the level inputs

--LOCAL FUNCTIONS--

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

	if isTouch then return end

	local s = Util.findId("player")
	if s then s:mousepressed(x, y, button, istouch) end --Handles keypressing for player

	registerTap(x, y, MUSIC_BEAT)

end

function state:touchpressed(id, x, y, dx, dy, pressure)
	local s = Util.findId("player")

	if s then s:touchpressed(id, x, y, dx, dy, pressure) end --Handles touch for player

	registerTap(x, y, MUSIC_BEAT)
end

function state:touchmoved(...)
	local s = Util.findId("player")

	if s then s:touchmoved(...) end --Handles moving touch for player
end

--LOCAL FUNCTIONS

function registerTap(x, y, beat)

	print("tap registered: x:"..x .." y:"..y.." beat:"..beat)

	table.insert(level,{x,y,beat})
	local file = io.open("level.txt", "w")
	for enemy in pairs(level) do
		file:write(string.format("Enemy.create("..level[enemy][1].." y:"..level[enemy][2].." beat:"..level[enemy][3].."\r\n"))
	end
	file:close()
end

--Return state functions
return state
