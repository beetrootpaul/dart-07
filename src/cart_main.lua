-- -- -- -- -- -- --
-- cart_main.lua  --
-- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local preselected_mission_number = _get_cart_param(1)

    -- to clear cart data, go to cart data folder (defined as "root_path" in "$HOME/Library/Application Support/pico-8/config.txt")
    -- and delete "todo-shmup.p8d.txt" file
    cartdata("todo-shmup")

    current_screen = preselected_mission_number and
        new_screen_select_mission(preselected_mission_number) or
        new_screen_brp()
    current_screen._init()
end

function _update60()
    next_screen = current_screen._post_draw()

    if next_screen then
        current_screen = next_screen
        current_screen._init()
    end

    current_screen._update()
end

function _draw()
    current_screen._draw()
    pal(_palette_display, 1)
end

-- TODO: selection screen: game logo OR separate title screen and selection+score screen

-- TODO: API file: UNPACK
-- TODO: API file: DGET
-- TODO: API file: DSET
-- TODO: API file: CARTDATA
-- TODO: API file: MUSIC
-- TODO: API file: MEMCPY
-- TODO: API file: LOAD

-- TODO: CARTDATA: update used ID to the final one, both in function calls as in the comments below them

-- TODO: polishing: screen mission select; with info which button to press to progress 

-- TODO: polishing: SFX: enemy bullets
-- TODO: polishing: SFX: shared

-- TODO: polishing: music: mission selection
-- TODO: polishing: music: mission 1
-- TODO: polishing: music: mission 1 boss
-- TODO: polishing: music: mission 2
-- TODO: polishing: music: mission 2 boss
-- TODO: polishing: music: mission 3
-- TODO: polishing: music: mission 3 boss

-- TODO: polishing: sprites: mission 2: enemies 
-- TODO: polishing: sprites: mission 2: boss 
-- TODO: polishing: sprites: mission 3: enemies 
-- TODO: polishing: sprites: mission 3: boss 

-- TODO: polishing: explosions: player hit
-- TODO: polishing: explosions: player destroyed
-- TODO: polishing: explosions: enemy destroyed
-- TODO: polishing: explosions: boss hit with a shockwave
-- TODO: polishing: explosions: boss enters next phase
-- TODO: polishing: explosions: boss destroyed

-- TODO: boss info: boss 1 name
-- TODO: boss info: boss 2 name
-- TODO: boss info: boss 3 name

-- TODO: tutorial screen? press X to shoot, arrows to fly; X can be pressed long, C cannot

-- TODO: balancing: powerup distributions 
-- TODO: balancing: enemy types, health, speed, their bullets: timer, speed, amount, angles, timer, SFX or not 
-- TODO: balancing: player speed, its bullets: speed 1, speed 2, throttle length, shockwave: throttle length 
-- TODO: balancing: shockwave damage time and amount 

-- TODO: carts: label images

-- TODO: final BBS IDs in LOAD

-- TODO: itch.io: favicon

-- TODO: GitHub repo: license other than MIT?
-- TODO: GitHub repo: final name
-- TODO: GitHub repo: description & website & topics

-- TODO: continue performance_check git branch for 4+ stationary enemies at the same time + fast shot + triple shot

-- TODO: check if no DEBUG code is left uncommented

-- TODO: title screen with logo and score and tutorial? and go to screen with only mission selection?

-- TODO: consider this left-right enemy type for mission 2
-- enemy: left-right
--[76] = {
--    movement_factory = new_movement_loop_factory({
--        new_movement_line_factory {
--            base_speed_y = .25,
--            frames = 160,
--            angle = 0,
--            angled_speed = .5,
--        },
--        new_movement_line_factory {
--            base_speed_y = .25,
--            frames = 160,
--            angle = .5,
--            angled_speed = .5,
--        },
--    }),
--},