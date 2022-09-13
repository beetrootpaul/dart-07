-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_win.lua --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_win()
    local fade_out = new_fade("out", 30)

    local proceed = false

    --

    local screen = {}

    function screen._init()
        -- this music is available on the last mission's cart only
        music(2)
    end

    function screen._update()
        if btnp(_button_x) then
            _music_fade_out()
            _sfx_play(_sfx_options_confirm)
            proceed = true
        end

        if proceed then
            fade_out._update()
        end
    end

    function screen._draw()
        cls(_color_0_black)

        print("win!", 10, 40, _color_4_true_blue)
        print("press x", 10, 60, 1 + flr(sin(2 * t())) == 0 and _color_6_light_grey or _color_14_mauve)

        fade_out._draw()
    end

    function screen._post_draw()
        if fade_out.has_finished() then
            _load_main_cart {
                preselected_mission_number = _m.mission_number,
            }
        end
    end

    return screen
end
