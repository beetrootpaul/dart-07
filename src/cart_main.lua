-- -- -- -- -- -- --
-- cart_main.lua  --
-- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local preselected_mission_number = _get_cart_param(1)

    -- to clear cart data, go to cart data folder (defined as "root_path" in "$HOME/Library/Application Support/pico-8/config.txt")
    -- and delete "todo-shmup.p8d.txt" file
    cartdata("todo-shmup")

    current_screen = preselected_mission_number ~= nil and
        new_screen_select_mission { preselected_mission_number = tonum(preselected_mission_number) } or
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

    _remap_display_colors()
end

-- TODO: API file: DGET
-- TODO: API file: DSET
-- TODO: API file: CARTDATA
-- TODO: API file: MUSIC
-- TODO: API file: MEMCPY
-- TODO: API file: LOAD

-- TODO: CARTDATA: update used ID to the final one, both in function calls as in the comments below them

-- TODO: polishing: screen mission select; with info which button to press to progress 
-- TODO: polishing: screen win; with info which button to press to progress
-- TODO: polishing: screen over; with info which button to press to progress

-- TODO: polishing: negative palette

-- TODO: polishing: boss health bar

-- TODO: polishing: SFX: enemy bullets
-- TODO: polishing: SFX: shared

-- TODO: polishing: music: mission selection
-- TODO: polishing: music: mission 1
-- TODO: polishing: music: mission 1 boss
-- TODO: polishing: music: mission 2
-- TODO: polishing: music: mission 2 boss
-- TODO: polishing: music: mission 3
-- TODO: polishing: music: mission 3 boss

-- TODO: polishing: sprites: enemy 
-- TODO: polishing: sprites: structure
-- TODO: polishing: sprites: enemy bullets
-- TODO: polishing: sprites: player
-- TODO: polishing: sprites: player bullet

-- TODO: polishing: player invincibility

-- TODO: polishing: explosions: player hit
-- TODO: polishing: explosions: player destroyed
-- TODO: polishing: explosions: enemy hit
-- TODO: polishing: explosions: enemy hit with a shockwave
-- TODO: polishing: explosions: enemy destroyed
-- TODO: polishing: explosions: boss hit
-- TODO: polishing: explosions: boss hit with a shockwave
-- TODO: polishing: explosions: boss enters next phase
-- TODO: polishing: explosions: boss destroyed

-- TODO: polishing: sliding info: 1a. mission names
-- TODO: polishing: sliding info: 1b. boss names
-- TODO: polishing: sliding info:  2. look&feel

-- TODO: polishing: mission 1: waves 
-- TODO: polishing: mission 2: stars 
-- TODO: polishing: mission 3: particles 

-- TODO: score and persisted high score

-- TODO: tutorial screen? press X to shoot, arrows to fly; X can be pressed long, C cannot

-- TODO: screen shake? and a menu item to disable screen shake?

-- TODO: "hit stop" on player damage?

-- TODO: push enemies and boss on damage?

-- TODO: powerup magnet?
-- TODO: powerup retrieval after damage?

-- TODO: balancing: powerup distributions 
-- TODO: balancing: enemy types, health, speed, their bullets: timer, speed, amount, angles, timer, SFX or not 
-- TODO: balancing: player speed, its bullets: speed 1, speed 2, throttle length, shockwave: throttle length 
-- TODO: balancing: shockwave damange time and amount 

-- TODO: consider angled triple-shot  

-- TODO: carts: title comments
-- TODO: carts: labels

-- TODO: final BBS IDs in LOAD

-- TODO: itch.io: favicon

-- TODO: GitHub repo: license other than MIT?
-- TODO: GitHub repo: final name
-- TODO: GitHub repo: description & website & topics