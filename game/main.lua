--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"
Camera    = require "hump.camera"
Vector    = require "hump.vector"

--OTHER EXTRA LIBS
require "extra_libs.slam"

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
Res       = require "res_manager"


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

    --[[
        Setup support for multiple resolutions. Res.init() Must be called after Gamestate.registerEvents()
        so it will properly call the draw function applying translations.
    ]]
    Res.init()

    Gamestate.switch(GS.MENU)  --Jump to the inicial state

end
