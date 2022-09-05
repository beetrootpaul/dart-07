-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_win.lua --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: create a decent win screen

-- TODO NEXT: fade out

function new_screen_win()
    local proceed = false

    --

    local screen = {}

    function screen._init()
        -- TODO: music
    end

    function screen._update()
        if btnp(_button_x) then
            proceed = true
        end
    end

    function screen._draw()
        cls(_color_0_black)

        print("win!", 10, 40, _color_12_true_blue)
        print("press x", 10, 60, 1 + flr(sin(2 * t())) == 0 and _color_6_light_grey or _color_13_mauve)
        print("score: ", 10, 80, _color_3_blue_green)
        -- TODO NEXT: implement and show conditionally
        print("new high score!", 10, 100, _color_3_blue_green)
    end

    function screen._post_draw()
        if proceed then
            _load_main_cart {
                preselected_mission_number = _m.mission_number,
            }
        end
    end

    return screen
end
