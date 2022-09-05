-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_title.lua --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: create a decent title screen

function new_screen_title()
    local should_go_to_mission_selection = false

    --

    local screen = {}

    function screen._init()
        -- TODO: music
    end

    function screen._update()
        -- TODO: make it clear for the user which button is to be pressed
        if btnp(_button_x) then
            should_go_to_mission_selection = true
        end
    end

    function screen._draw()
        cls(_color_0_black)

        print("todo shmup", 34, 50, _color_15_peach)
        print("press x", 34, 60, _color_6_light_grey)
        -- TODO: high score across plays (persistent storage)
        print("high score:", 34, 80, _color_12_true_blue)
    end

    function screen._post_draw()
        if should_go_to_mission_selection then
            return new_screen_select_mission()
        end
    end

    return screen
end
