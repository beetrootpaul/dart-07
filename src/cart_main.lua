-- -- -- -- -- -- --
-- cart_main.lua  --
-- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local preselected_mission_number = _get_cart_param(1)
    -- DEBUG:
    preselected_mission_number = 1

    -- to clear cart data, go to cart data folder (defined as "root_path" in "$HOME/Library/Application Support/pico-8/config.txt")
    -- and delete "brp_dart-07.p8d.txt" file
    cartdata("brp_dart-07")

    current_screen = preselected_mission_number and
        new_screen_title(preselected_mission_number, true, false, false) or
        new_screen_brp()
    -- DEBUG:
    --current_screen = new_screen_controls(preselected_mission_number)
    --current_screen = new_screen_title(preselected_mission_number, false, true, false)
    --current_screen = new_screen_select_mission(preselected_mission_number)

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

-- TODO: polishing: music: mission 2
-- TODO: polishing: music: mission 2 boss
-- TODO: polishing: music: mission 3
-- TODO: polishing: music: mission 3 boss

-- TODO: polishing: sprites: mission 2: enemies 
-- TODO: polishing: sprites: mission 2: boss 
-- TODO: polishing: sprites: mission 3: enemies 
-- TODO: polishing: sprites: mission 3: boss 

-- TODO: balancing: powerup distributions: mission 2
-- TODO: balancing: powerup distributions: mission 3
-- TODO: balancing: mission 2: enemy types, health, speed, their bullets: timer, speed, amount, angles, timer, SFX or not 
-- TODO: balancing: mission 3: enemy types, health, speed, their bullets: timer, speed, amount, angles, timer, SFX or not 

-- TODO: carts: label images: mission 1
-- TODO: carts: label images: mission 2
-- TODO: carts: label images: mission 3

-- TODO: itch.io: favicon

-- TODO: check if no DEBUG code is left uncommented

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