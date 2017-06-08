--HUMP MODULES
Gamestate = require "extra_libs.hump.gamestate"
Timer     = require "extra_libs.hump.timer"
Class     = require "extra_libs.hump.class"
Camera    = require "extra_libs.hump.camera"
Vector    = require "extra_libs.hump.vector"
Signal    = require 'extra_libs.hump.signal'

--OTHER EXTRA LIBS

require "extra_libs.Tserial" --For packing and unpacking tables


--CLASSES
require "classes.primitive"
Color = require "classes.color.color"
require "classes.text"
require "classes.color.rgb"
require "classes.color.hsl"
require "classes.paddle"
require "classes.ball"
require "classes.brick"
require "classes.button"
require "classes.editor_box"
require "classes.particle"

--MY MODULES

Util      = require "util"
Draw      = require "draw"
Setup     = require "setup"
Font      = require "font"
Res       = require "res_manager"
FM        = require "file_manager"
FX        = require "fx"

--GAMESTATES
GS = {
MENU      = require "gamestates.menu",     --Menu Gamestate
GAME      = require "gamestates.game",     --Game Gamestate
LVL_EDT   = require "gamestates.level_editor",  --Level Editor Gamestate
CSTM_LVLS = require "gamestates.custom_levels", --Custom Levels Gamestate
}

------------------
--LÖVE FUNCTIONS--
------------------


function love.load()


    Setup.config() --Configure your game

    Gamestate.registerEvents() --Overwrites love callbacks to call Gamestate as well

    --[[
        Setup support for multiple resolutions. Res.init() Must be called after Gamestate.registerEvents()
        so it will properly call the draw function applying translations.
    ]]
    Res.init() --Setup support for multiple resolutions.; Must be called after gamestt

    Gamestate.switch(GS.MENU) --Jump to the inicial state

end

--Function called when love is quitting
function love.quit()
    local sucess

    print("Exiting the game. Please hold while we save your information.")

    --Save all status on the files
    sucess = FM.save()
    if not sucess then
        print("Couldn't update your save in the savefile. Aborting the exit of the game. You can press 'escape' to forcefully close the game while on the menu screen without trying to save.")
        return false
    end

    print("Game saved. Thanks for grooving")
    print("---------------------------")

    return true
end
