-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_title.lua --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_title(preselected_mission)
    local high_score

    local fade_in = new_fade("in", 30)

    local proceed = false

    --

    local screen = {}

    function screen._init()
        music(0)

        high_score = dget(0)
        -- DEBUG:
        --high_score = 123
    end

    function screen._update()
        if btnp(_button_x) then
            _sfx_play(_sfx_options_confirm)
            proceed = true
        end

        fade_in._update()
    end

    function screen._draw()
        cls(_color_1_darker_blue)

        print("shmup", 34, 10, _color_15_peach)

        if high_score > 0 then
            print("high score", 10, 25, _color_6_light_grey)
            new_score(high_score)._draw(70, 25, _color_6_light_grey, _color_2_darker_purple)
        end

        fade_in._draw()
    end

    function screen._post_draw()
        if proceed then
            return new_screen_select_mission(preselected_mission)
        end
    end

    return screen
end
