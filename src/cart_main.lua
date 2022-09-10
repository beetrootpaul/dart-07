-- -- -- -- -- -- --
-- cart_main.lua  --
-- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local cart_params = _parse_main_cart_params()
    
    -- TODO: describe CARTDATA in API file
    -- TODO: update ID to the final one
    cartdata("todo-shmup")

    if cart_params.preselected_mission_number ~= nil then
        current_screen = new_screen_select_mission {
            preselected_mission_number = cart_params.preselected_mission_number,
        }
    else
        current_screen = new_screen_brp()
    end
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

-- TODO: texts shaded with 2 horizontal colors

-- TODO: tutorial screen? press X to shoot, arrows to fly
-- TODO: screen shake?
-- TODO: menu item to disable screen shake?

-- TODO: "hit stop"?

-- TODO: push enemies and boss on damage?

-- TODO: menu music
-- TODO: music per stage
-- TODO: music per boss stage

-- TODO: balancing: powerup distributions 
-- TODO: balancing: enemy speed 
-- TODO: balancing: enemy bullet timer 
-- TODO: balancing: enemy bullet movement 
-- TODO: balancing: enemy movement 
-- TODO: balancing: player bullet timer 
-- TODO: balancing: player bullet movement 
-- TODO: balancing: boss movement, including easing fns
-- TODO: balancing: boss bullet timer
-- TODO: balancing: boss bullet movement

-- TODO: consider license other than MIT

-- TODO: itch.io: favicon

-- TODO: GitHub repo: final name
-- TODO: GitHub repo: description & website & topics