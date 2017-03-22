--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --IMAGES--

    --RANDOM SEED--
    love.math.setRandomSeed( os.time() )

    --GLOBAL VARIABLES--
    DEBUG = true --DEBUG mode status

    WIN_W = 1200 --Current width of the game window
    WIN_H = 600 --Current height of the game window

    BPM_M = 128 --Beats per minute of current BGM
    BPM_C = 0   --BPM counter

    MUSIC_BEAT = 0 --Tracks which part of the bgm is playing (in beats)

    PULSE_TIME = .2 --Time for ship to start and finish a pulse

    TILESIZE = 80
    GRID_ROWS = 3  --How many rows the grid has
    GRID_COLS = 15 --How many tiles per row

    --TIMERS--
    MAIN_TIMER = Timer.new()  --General Timer

    --INITIALIZING TABLES--

    --Drawing Tables
    DRAW_TABLE = {
    BG  = {}, --Background (bottom layer, first to draw)
    L1  = {}, --Layer 1
    L2  = {}, --Layer 2
    GUI = {}  --Graphic User Interface (top layer, last to draw)
    }

    --Other Tables
    SUBTP_TABLE = {} --Table with tables for each subtype (for fast lookup)
    ID_TABLE = {} --Table with elements with Ids (for fast lookup)

    --WINDOW CONFIG--
    love.window.setMode(WIN_W, WIN_H)

    --CAMERA--
    CAM = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2) --Set camera position to center of screen

    --SHADERS--

    --AUDIO--

end

--Return functions
return setup
