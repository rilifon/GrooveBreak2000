--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )
    love.math.setRandomSeed( os.time() )

    args = FM.load() --Load from savefile (or create one if needed)

    --IMAGES--
    IMG_ICE_BLOCK = love.graphics.newImage("assets/images/ice_block.png")

    --GLOBAL VARIABLES--
    DEBUG = false --DEBUG mode status

    local w, h = love.graphics.getDimensions() --Get current window size

    O_WIN_W = 1536 --Default width of the game window
    O_WIN_H = 2276 --Default height of the game window

    MOUSE_IS_DRAGGING_BRICK = false --If mouse is already dragging a brick, so it doesn't drag anything else
    TOUCH_IS_DRAGGING_BRICK = {} --If a touch id is already dragging a brick, so it doesn't drag anything else

    CUSTOM_LEVELS = args.custom_levels --All custom levels created by the player

    --TIMERS--
    MAIN_TIMER = Timer.new()  --General Timer

    --INITIALIZING TABLES--
    --Drawing Tables
    DRAW_TABLE = {
        BG  = {}, --Background (bottom layer, first to draw)
        EDITOR = {}, --Editor BOx layer
        L0  = {},    --Layer 0
        L1  = {},    --Layer 1
        L2  = {},    --Layer 2
        L3  = {},    --Layer 3
        GUI = {}     --Graphic User Interface (top layer, last to draw)
    }

    --Other Tables
    SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
    ID_TABLE = {} --Table with elements with Ids (for fast lookup)

    --CAMERA--
    CAM = Camera(O_WIN_W/2, O_WIN_H/2) --Set camera position to center of screen

    --FONTS--
    Font.new("nevis", "assets/fonts/Nevis.ttf")

    --SHADERS--
        --

    --AUDIO--
       --



end

--Return functions
return setup
