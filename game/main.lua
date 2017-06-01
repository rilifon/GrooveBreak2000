--HUMP STUFF
Gamestate = require "extra_libs.hump.gamestate"
Timer     = require "extra_libs.hump.timer"
Class     = require "extra_libs.hump.class"
Camera    = require "extra_libs.hump.camera"
Vector    = require "extra_libs.hump.vector"

--OTHER EXTRA LIBS
FreeRes = require "extra_libs.FreeRes"


--CLASSES
require "classes.primitive"
Color = require "classes.color.color"
require "classes.color.rgb"
require "classes.color.hsl"
require "classes.paddle"


--MY MODULES
Util      = require "util"
Draw      = require "draw"
Setup     = require "setup"
Font      = require "font"




--GAMESTATES
GS = {
--MENU     = require "gamestate.menu",     --Menu Gamestate
GAME     = require "gamestates.game",     --Game Gamestate
--PAUSE    = require "gamestate.pause",    --Pause Gamestate
--GAMEOVER = require "gamestate.gameover"  --Gameover Gamestate
}

------------------
--LÖVE FUNCTIONS--
------------------

function love.load()

    Setup.config() --Configure your game

    Gamestate.registerEvents() --Overwrites love callbacks to call Gamestate as well
    Gamestate.switch(GS.GAME) --Jump to the inicial state

end

--Called when user resizes the screen
function love.resize(w, h)

    WINDOW_WIDTH = w
    WINDOW_HEIGHT = h

    FreeRes.setScreen() --Refresh FreeRes library to handle screen resolutions

end
