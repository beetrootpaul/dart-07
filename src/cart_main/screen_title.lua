-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_title.lua --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: create a screen with tutorial where one can move ship around and shoot

-- TODO: create a decent title screen

function new_screen_title(params)
    local preselected_mission_number = params.preselected_mission_number

    local proceed = false

    local fade_in = new_fade("in", 30)

    --

    local screen = {}

    function screen._init()
        -- TODO: music
    end

    function screen._update()
        -- TODO: make it clear for the user which button is to be pressed
        if btnp(_button_x) then
            proceed = true
        end

        fade_in._update()
    end

    function screen._draw()
        cls(_color_11_dark_green)

        print("todo shmup", 34, 50, _color_15_peach)
        print("press x", 34, 60, 1 + flr(sin(2 * t())) == 0 and _color_6_light_grey or _color_13_mauve)
        -- TODO NEXT: high score across plays (persistent storage)
        print("high score:", 34, 80, _color_12_true_blue)

        fade_in._draw()
    end

    function screen._post_draw()
        if proceed then
            return new_screen_select_mission {
                preselected_mission_number = preselected_mission_number,
            }
        end
    end

    return screen
end
