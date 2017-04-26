--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed, window configuration and anything else needed
function setup.config()

    --IMAGES--

    print("Loading Images...")
    --Player image
    IMG_PLAYER = love.graphics.newImage("assets/images/girl01.png")

    --Enemies Images
    IMG_ENEMY1 = love.graphics.newImage("assets/images/enemy01_01.png")

    --Background Images
    IMG_BG = love.graphics.newImage("assets/images/bg_resized.png")
    IMG_CLOUD = love.graphics.newImage("assets/images/cloud01.png")
    IMG_PARALAX1 = love.graphics.newImage("assets/images/paralax_01.png")
    IMG_PARALAX2 = love.graphics.newImage("assets/images/paralax_02.png")

    --Shot Image
    IMG_SHOT1 = love.graphics.newImage("assets/images/shot_small01.png")
    print("Finished Loading Images!")

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

    WINDOW_DIVISION = 2*WIN_W/3 --Division where window touch is reserved for player movement (left) or shooting (right)

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
    --Tracks
    BGM_MAIN = love.audio.newSource("assets/bgm/mus_jogodenave_loop.wav")
    --SFX
    SFX_AMBIENCE = love.audio.newSource("assets/sfx/amb_sky_loop.mp3")
    SFX_AMBIENCE:setLooping(true)
    SFX_ENEMY_SHOT = love.audio.newSource("assets/sfx/sfx_enemy_shot.mp3")
    SFX_HITENEMY =  love.audio.newSource({
                    "assets/sfx/hit_enemy_sfx/sfx_hitenemy_var01.mp3",
                    "assets/sfx/hit_enemy_sfx/sfx_hitenemy_var02.mp3",
                    "assets/sfx/hit_enemy_sfx/sfx_hitenemy_var03.mp3",
                    "assets/sfx/hit_enemy_sfx/sfx_hitenemy_var04.mp3",
                    "assets/sfx/hit_enemy_sfx/sfx_hitenemy_var05.mp3",
                    "assets/sfx/hit_enemy_sfx/sfx_hitenemy_var06.mp3",
                  })
    SFX_PLAYER_SHOT = love.audio.newSource({
        "assets/sfx/player_shot_sfx/sfx_player_shot1.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot2.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot3.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot4.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot5.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot6.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot7.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot8.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot9.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot10.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot11.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot12.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot13.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot14.mp3",
        "assets/sfx/player_shot_sfx/sfx_player_shot15.mp3",
        })

end

--Return functions
return setup
