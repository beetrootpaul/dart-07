-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_select_mission.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: unlock levels with progression
-- TODO: extra option to go back
-- TODO: high score
-- TODO: create a decent mission selection screen

function new_screen_select_mission(params)
    local selected_mission = params.preselected_mission_number

    local fade_in = new_fade("in", 30)
    local fade_out = new_fade("out", 30)

    local proceed = false

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
            proceed = true
        end

        if proceed then
            fade_out._update()
        else
            fade_in._update()
        end
    end

    function screen._draw()
        cls(_color_11_dark_green)

        print("todo shmup", 34, 10, _color_15_peach)
        print("mission 1", 30, 30, selected_mission == 1 and _color_6_light_grey or _color_13_mauve)
        print("mission 2", 30, 50, selected_mission == 2 and _color_6_light_grey or _color_13_mauve)
        print("mission 3", 30, 70, selected_mission == 3 and _color_6_light_grey or _color_13_mauve)
        -- TODO: high score across plays (persistent storage)
        --print("high score:", 34, 80, _color_12_true_blue)

        fade_out._draw()
        fade_in._draw()
    end

    function screen._post_draw()
        if fade_out.has_finished() then
            _copy_shared_assets_from_transferable_ram()
            _load_mission_cart {
                mission_number = selected_mission,
                health = _health_default,
                shockwave_charges = _shockwave_charges_default,
                triple_shot = false,
                fast_shoot = false,
            }
        end
    end

    return screen
end
