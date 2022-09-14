-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_select_mission.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_select_mission(params)
    local selected_mission = params.preselected_mission_number

    local fade_in = new_fade("in", 30)
    local fade_out = new_fade("out", 30)

    local max_unlocked_mission

    local proceed = false

    --

    local screen = {}

    function screen._init()
        music(0)
        max_unlocked_mission = max(dget(0), 1)
    end

    function screen._update()
        if btnp(_button_up) then
            _sfx_play(_sfx_options_change)
            selected_mission = selected_mission - 1
        end
        if btnp(_button_down) then
            _sfx_play(_sfx_options_change)
            selected_mission = selected_mission + 1
        end
        selected_mission = (selected_mission - 1) % _max_mission_number + 1

        if btnp(_button_x) then
            if selected_mission <= max_unlocked_mission then
                _music_fade_out()
                _sfx_play(_sfx_options_confirm)
                proceed = true
            else
                _sfx_play(_sfx_options_cannot_confirm)
            end
        end

        (proceed and fade_out or fade_in)._update()
    end

    function screen._draw()
        cls(_color_3_dark_green)

        print("shmup", 34, 10, _color_15_peach)
        print("mission 1", 30, 30, 1 <= max_unlocked_mission and (selected_mission == 1 and _color_6_light_grey or _color_13_lavender) or (selected_mission == 1 and _color_8_red or _color_14_mauve))
        print("mission 2", 30, 50, 2 <= max_unlocked_mission and (selected_mission == 2 and _color_6_light_grey or _color_13_lavender) or (selected_mission == 2 and _color_8_red or _color_14_mauve))
        print("mission 3", 30, 70, 3 <= max_unlocked_mission and (selected_mission == 3 and _color_6_light_grey or _color_13_lavender) or (selected_mission == 3 and _color_8_red or _color_14_mauve))

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
