-- -- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_controls.lua --
-- -- -- -- -- -- -- -- -- -- -- --

function new_screen_controls(preselected_mission)
    local x_sprite = new_static_sprite("15,6,56,0", true)
    local x_pressed_sprite = new_static_sprite("15,6,56,6", true)
    local c_o_sprite = new_static_sprite("15,6,56,24", true)
    local pause_sprite = new_static_sprite("15,6,41,0", true)

    local proceed = false

    local function draw_controls(base_y)
        local y = base_y
        print("controls", 10, y, _color_7_white)

        y = y + 10
        print("in \-fgame:", 10, y, _color_7_white)

        y = y + 10
        print("use \-farrows \-fto \-fnavigate", 10, y, _color_6_light_grey)

        y = y + 10
        print("press \-fand \-fhold", 10, y, _color_6_light_grey)
        x_sprite._draw(-_gaox + 68, y - 1)
        print("to \-ffire", 84, y, _color_6_light_grey)

        y = y + 10
        print("press", 10, y, _color_6_light_grey)
        c_o_sprite._draw(-_gaox + 34, y - 1)
        print("to \-ftrigger", 50, y, _color_6_light_grey)
        print("a \-fshockwave \-f(if \-favailable)", 10, y + 6, _color_6_light_grey)

        y = y + 30
        print("other:", 10, y, _color_7_white)

        y = y + 10
        print("press", 10, y, _color_6_light_grey)
        pause_sprite._draw(-_gaox + 34, y - 1)
        print("to \-fopen", 50, y, _color_6_light_grey)
        print("a \-fpause \-fmenu", 10, y + 6, _color_6_light_grey)

        y = y + 20
        print("press", 10, y, _color_6_light_grey)
        x_sprite._draw(-_gaox + 34, y - 1)
        print("to \-fconfirm", 84, y, _color_6_light_grey)
    end

    local function draw_back_button(base_y)
        -- button shape
        sspr(35, 12, 1, 12, 10, base_y, 50, 12)

        -- button text
        print("back", 14, base_y + 3, _color_14_mauve)

        -- "x" press incentive
        local sprite = _alternating_0_and_1() == 0 and x_sprite or x_pressed_sprite
        sprite._draw(-_gaox + 44, base_y + 13)
    end

    --

    local screen = {
        _init = _noop,
    }

    function screen._update()
        if btnp(_button_x) then
            _sfx_play(_sfx_options_confirm)
            proceed = true
        end
    end

    function screen._draw()
        cls(_color_1_darker_blue)

        draw_controls(10)
        draw_back_button(90)
    end

    function screen._post_draw()
        if proceed then
            return new_screen_title(preselected_mission, false)
        end
    end

    return screen
end
