--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --IMAGES--
       --

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    local w, h = love.graphics.getDimensions() --Get current window size

    WINDOW_WIDTH = w --Current width of the game window
    WINDOW_HEIGHT = h --Current height of the game window
    O_WIN_W = 1536 --Default width of the game window
    O_WIN_H = 2276 --Default height of the game window


    --TIMERS--
    MAIN_TIMER = Timer.new()  --General Timer

    --INITIALIZING TABLES--
    --Drawing Tables
    DRAW_TABLE = {
    BG  = {}, --Background (bottom layer, first to draw)
    L1  = {}, --Layer 1
    L2  = {}, --Layer 2
    L3  = {}, --Layer 3
    GUI = {}  --Graphic User Interface (top layer, last to draw)
    }

    --Other Tables
    SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
    ID_TABLE = {} --Table with elements with Ids (for fast lookup)

    --WINDOW CONFIG--
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {resizable = true, minwidth = 100, minheight = 100})
    FreeRes.setScreen() --Setup FreeRes library to handle screen resolutions

    --CAMERA--
    CAM = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2) --Set camera position to center of screen

    --SHADERS--
        --

    --AUDIO--
       --

end

--Return functions
return setup
