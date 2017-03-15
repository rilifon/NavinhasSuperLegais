local Util = require "util"
local Draw = require "draw"
local Ship = require "classes.ship"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}

function state:enter()
	Ship.create()
end

function state:leave()

end


function state:update(dt)
	local s = Util.findId("player")

	--Update bmp counter
	BPM_C = BPM_C + dt
	if BPM_C >= 60/BPM_M then
		--Reached "pulse" time
		BPM_C = BPM_C - 60/BPM_M

		if s then s:pulse() end
	end

	Util.updateDrawTable(dt)

	Util.updateTimers(dt)

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

function state:keyreleased(key)
	local s = Util.findId("player")

	if s then s:keyreleased(key) end --Handles keypressing for player

end

--Return state functions
return state
