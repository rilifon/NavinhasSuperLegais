--EXTRA LIBS
require "extra_libs.slam"
FreeRes = require "extra_libs.FreeRes"

--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"
Camera    = require "hump.camera"
Vector    = require "hump.vector"


--CLASSES
require "classes.primitive"
Color = require "classes.color"
require "classes.ship"
require "classes.bullet"
require "classes.enemy"
require "classes.button"
require "classes.bgm"

--MY MODULES
Util      = require "util"
Draw      = require "draw"
Setup     = require "setup"
Font      = require "font"


--GAMESTATES
GS = {
    MENU     = require "gamestates.menu",          --Menu Gamestate
    GAME     = require "gamestates.game",          --Game Gamestate
    EDITOR   = require "gamestates.level_editor",  --Game Editor Gamestate
    --PAUSE    = require "gamestates.pause",    --Pause Gamestate
    --GAMEOVER = require "gamestates.gameover"  --Gameover Gamestate
}

function love.load()

    Setup.config() --Configure your game

    Gamestate.registerEvents() --Overwrites love callbacks to call Gamestate as well
    Gamestate.switch(GS.MENU)  --Jump to the inicial state

end

--Called when user resizes the screen
function love.resize(w, h)

    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h

    FreeRes.setScreen()

end

-----------------
--MOUSE FUNCTIONS
-----------------

function love.mousepressed(x, y, button, istouch)

    --[[
    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
    end
    ]]

end
