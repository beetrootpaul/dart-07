-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_title.lua --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_title(preselected_mission, start_music_and_fade_in, select_controls)
    local high_score

    local fade_in = new_fade("in", 30)

    local x_sprite = new_static_sprite("15,6,56,0", true)
    local x_pressed_sprite = new_static_sprite("15,6,56,6", true)

    local play = not select_controls

    local proceed = false

    local function draw_title(base_y)
        sspr(
            96, 32,
            32, 26,
            (_vs - 96) / 2, base_y
        )
        sspr(
            96, 58,
            32, 26,
            (_vs - 96) / 2 + 32, base_y
        )
        sspr(
            96, 84,
            32, 26,
            (_vs - 96) / 2 + 64, base_y
        )
    end

    local function draw_high_score(base_y)
        _centered_print("high \-fscore", base_y, _color_6_light_grey)
        new_score(high_score)._draw(52, base_y + 10, _color_7_white, _color_14_mauve)
    end

    local function draw_button(text, w, base_x, base_y, selected)
        -- button shape
        sspr(
            selected and 35 or 36, 12,
            1, 12,
            base_x, base_y,
            w, 12
        )

        -- button text
        print(text, base_x + 4, base_y + 3, _color_14_mauve)

        -- "x" press incentive
        if selected then
            local sprite = _alternating_0_and_1() == 0 and x_sprite or x_pressed_sprite
            sprite._draw(-_gaox + base_x + w - 16, base_y + 13)
        end
    end

    --

    local screen = {}

    function screen._init()
        if start_music_and_fade_in then
            music(0)
        end

        high_score = dget(0)
        -- DEBUG:
        --high_score = 123
    end

    function screen._update()
        if btnp(_button_up) or btnp(_button_down) then
            _sfx_play(_sfx_options_change)
            play = not play
        end

        if btnp(_button_x) then
            _sfx_play(_sfx_options_confirm)
            proceed = true
        end

        fade_in._update()
    end

    function screen._draw()
        cls(_color_1_darker_blue)
        map(0, 0, 0, 0, 16, 16)

        draw_title(15)
        draw_high_score(57)
        draw_button("play", 98, 15, 82, play)
        draw_button("controls", 98, 15, 104, not play)

        if start_music_and_fade_in then
            fade_in._draw()
        end
    end

    function screen._post_draw()
        if proceed then
            if play then
                return new_screen_select_mission(preselected_mission)
            else
                return new_screen_controls(preselected_mission)
            end
        end
    end

    return screen
end
