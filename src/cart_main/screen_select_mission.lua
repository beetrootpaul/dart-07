-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_select_mission.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: fade out to avoid instant color change, or… make fade in same color as selection screen
-- TODO NEXT: unlock levels with progression
-- TODO NEXT: extra option to go back
-- TODO NEXT: high score
-- TODO: create a decent mission selection screen

function new_screen_select_mission(params)
    local selected_mission = params.preselected_mission_number
    
    local should_start_mission = false

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        -- TODO: up/down SFX
        if btnp(_button_up) then
            selected_mission = selected_mission - 1
        end
        if btnp(_button_down) then
            selected_mission = selected_mission + 1
        end
        selected_mission = (selected_mission - 1) % _max_mission_number + 1

        -- TODO: make it clear for the user which button is to be pressed
        if btnp(_button_x) then
            should_start_mission = true
        end
    end

    function screen._draw()
        cls(_color_11_dark_green)

        print("mission 1", 30, 30, selected_mission == 1 and _color_6_light_grey or _color_13_mauve)
        print("mission 2", 30, 50, selected_mission == 2 and _color_6_light_grey or _color_13_mauve)
        print("mission 3", 30, 70, selected_mission == 3 and _color_6_light_grey or _color_13_mauve)
    end

    function screen._post_draw()
        if should_start_mission then
            _copy_shared_assets_from_transferable_ram()
            _load_mission_cart {
                mission_number = selected_mission,
                health = _health_default,
                is_triple_shot_enabled = false,
            }
        end
    end

    return screen
end
