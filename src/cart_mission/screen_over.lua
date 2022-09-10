-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_over.lua  --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_over()
    local fade_out = new_fade("out", 30)

    local retry, proceed = true, false

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        if btnp(_button_up) or btnp(_button_down) then
            sfx(_sfx_options_change, 3)
            retry = not retry
        end

        if btnp(_button_x) then
            _music_fade_out()
            sfx(_sfx_options_confirm, 3)
            proceed = true
        end

        if proceed then
            fade_out._update()
        end
    end

    function screen._draw()
        cls(_color_0_black)

        print("try again (mission " .. _m.mission_number .. ")", 10, 40, retry and _color_6_light_grey or _color_14_mauve)
        print("back to title", 10, 60, retry and _color_14_mauve or _color_6_light_grey)

        fade_out._draw()
    end

    function screen._post_draw()
        if fade_out.has_finished() then
            if retry then
                extcmd("reset")
            else
                _load_main_cart {
                    preselected_mission_number = _m.mission_number,
                }
            end
        end
    end

    return screen
end
