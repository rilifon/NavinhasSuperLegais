local Util = require "util"
local Draw = require "draw"
local Button = require "classes.button"
local Background = require "classes.background"
local Bgm = require "classes.bgm"

--MODULE FOR THE GAMESTATE: GAME--

local state = {}

--LOCAL VARIABLES--

local switch = nil --If game shoudl swith to another state

--LOCAL FUNCTIONS--

local checkCollisions

--STATE FUNCTIONS--

function state:enter()

	Bgm.create(SFX_AMBIENCE, 0, "ambience_sfx")

	local background = Background.create() --Create background
	background.draw_division = false

	--Start Game button
	Button.createRegularButton(400, 400, 400, 400, Color.red(), "Start Game", function() switch = "game" end)

	--Start Editor button
	Button.createRegularButton(400, 900, 400, 400, Color.red(), "Start Editor", function() switch = "editor" end)


end

function state:leave()

	for _,T in pairs(DRAW_TABLE) do
		Util.setAtributeTable(T, "death", true)
	end

	Util.destroyAll()

end


function state:update(dt)

	if switch == "game" then
		Gamestate.switch(GS.GAME)
	elseif switch == "editor" then
		Gamestate.switch(GS.EDITOR)
	end

	Util.updateDrawTable(dt)

	Util.updateId(dt, "ambience_sfx")

	Util.updateTimers(dt)

	Util.destroyAll()

end

function state:draw()

    Draw.allTables()

end

function state:keypressed(key)

    Util.defaultKeyPressed(key)    --Handles keypressing for general stuff

end

function state:mousepressed(x, y, button, istouch)

	local w, h = FreeRes.windowDistance()
    local scale = FreeRes.scale()
    x = x - w
    x = x*(1/scale)
    y = y - h
    y = y*(1/scale)

	checkButtonsCollisions(x, y)

end

function state:touchpressed(id, x, y, dx, dy, pressure)

	local w, h = FreeRes.windowDistance()
	local scale = FreeRes.scale()
	x = x - w
	x = x*(1/scale)
	y = y - h
	y = y*(1/scale)

	checkButtonsCollisions(x, y)

end


--LOCAL FUNCTIONS

--Iterate through all buttons and check for collision with (x,y) given
function checkButtonsCollisions(x, y)

	--Check collision with regular buttons
	reg_buts = Util.findSbTp("regular_buttons")
	if reg_buts then
		for but in pairs(reg_buts) do
			if Util.pointInRect({x = x, y = y}, {x = but.pos.x, y = but.pos.y, w = but.w, h = but.h}) then
				but.func()
			end
		end
	end
end

--Return state functions
return state
