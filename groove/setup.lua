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
    IMG_LAVA_BLOCK = love.graphics.newImage("assets/images/lava_block.png")
    IMG_ROCK_BLOCK = love.graphics.newImage("assets/images/rock_block.png")
    IMG_SHOVEL = love.graphics.newImage("assets/images/shovel.png")
    IMG_ICE_SHOVEL = love.graphics.newImage("assets/images/ice_shovel.png")
    IMG_FIRE_SHOVEL = love.graphics.newImage("assets/images/fire_shovel.png")
    IMG_BALL = love.graphics.newImage("assets/images/ball.png")
    IMG_ICE_BALL = love.graphics.newImage("assets/images/ice_ball.png")
    IMG_FIRE_BALL = love.graphics.newImage("assets/images/fire_ball.png")
    IMG_BG = love.graphics.newImage("assets/images/bg.png")
    IMG_LOGO = love.graphics.newImage("assets/images/logo.png")



    --GLOBAL VARIABLES--
    DEBUG = false --DEBUG mode status

    local w, h = love.graphics.getDimensions() --Get current window size

    O_WIN_W = 1536 --Default width of the game window
    O_WIN_H = 2276 --Default height of the game window

    BALL_START_POS_X = O_WIN_W/2
    BALL_START_POS_Y = 3*O_WIN_H/5

    MOUSE_IS_DRAGGING_BRICK = false --If mouse is already dragging a brick, so it doesn't drag anything else
    TOUCH_IS_DRAGGING_BRICK = {} --If a touch id is already dragging a brick, so it doesn't drag anything else

    LEVELS = require "levels" --Levels for the main game mode
    NUMBER_LEVELS = Util.tableLen(LEVELS) --Number of main levels
    CUR_LEVEL = nil --Current level the player is playing
    CUSTOM_LEVELS = args.custom_levels --All custom levels created by the player
    LEVEL_TO_LOAD = nil --What level the gamestate "game" should load

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
        L4  = {},    --Layer 4
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
    SFX_BALL_ON_FIRE_PADDLE = love.audio.newSource("assets/audio/sfx/bola_pegando_fogo.wav")
    SFX_BALL_ON_ICE_PADDLE = love.audio.newSource("assets/audio/sfx/bola_pegando_gelo.wav")
    SFX_ICE_BRICK_HIT  = love.audio.newSource("assets/audio/sfx/gelo_hit.wav")
    SFX_ICE_BRICK_BREAK  = love.audio.newSource("assets/audio/sfx/gelo_quebrando.wav")
    SFX_FIRE_BRICK_HIT  = love.audio.newSource("assets/audio/sfx/lava_hit.wav")
    SFX_FIRE_BRICK_BREAK  = love.audio.newSource("assets/audio/sfx/lava_quebrando.wav")
    SFX_ROCK_BRICK_HIT  = love.audio.newSource("assets/audio/sfx/pedra_batendo.wav")
    SFX_ROCK_BRICK_BREAK  = love.audio.newSource("assets/audio/sfx/pedra_quebrando.wav")
    SFX_DUMMY_HIT  = love.audio.newSource("assets/audio/sfx/impacto_sem_efeito.wav")
    SFX_NORMAL_HIT  = love.audio.newSource("assets/audio/sfx/bate_na_pa.wav")
    SFX_MENU_SELECT  = love.audio.newSource("assets/audio/sfx/menu_select.wav")
    SFX_GAMEOVER  = love.audio.newSource("assets/audio/sfx/perdeu_todas_as_stocks.wav")
    SFX_LOST_STOCK  = love.audio.newSource("assets/audio/sfx/perdeu_uma_stock.wav")
    SFX_FIRE_BRICK_HIT  = love.audio.newSource("assets/audio/sfx/lava_hit.wav")
    SFX_VICTORY  = love.audio.newSource("assets/audio/sfx/vitoria.wav")
    SFX_CHANGE_TYPE  = love.audio.newSource("assets/audio/sfx/troca_shovel.wav")

    SFX_FIRE_PERC  = love.audio.newSource("assets/audio/sfx/perc_fogo.wav")
    SFX_FIRE_PERC:setVolume(.9)
    SFX_FIRE_PERC:setLooping(true)
    SFX_ICE_PERC  = love.audio.newSource("assets/audio/sfx/perc_gelo.wav")
    SFX_ICE_PERC:setVolume(.08)
    SFX_ICE_PERC:setLooping(true)

    BGM_GAME = love.audio.newSource("assets/audio/tracks/ambience.mp3")
    BGM_GAME:setLooping(true)
    BGM_GAME_IS_PLAYING = nil
    BGM_MENU = love.audio.newSource("assets/audio/tracks/menu.mp3")
    BGM_MENU:setLooping(true)
    BGM_MENU_IS_PLAYING = nil









end

--Return functions
return setup
