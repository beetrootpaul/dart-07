-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_select_mission.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_select_mission(selected_mission)
    local high_score

    local fade_in = new_fade("in", 30)
    local fade_out = new_fade("out", 30)
    local ship_movement

    local proceed = false

    local ship_sprite = new_static_sprite "10,10,18,0"
    local jet_sprite = new_animated_sprite(
        4,
        4,
        split("0,0,0,0,4,4,4,4"),
        8
    )

    local function mission_button_xy_wh(mission_number)
        return _xy(_gaox, 43 + (mission_number - 1) * 29), _xy(_gaw, 16)
    end

    local function draw_mission_button(mission_number)
        local selected = selected_mission == mission_number

        local button_xy1, button_wh = mission_button_xy_wh(mission_number)
        local button_xy2 = button_xy1.plus(button_wh)

        -- draw level sample
        local sy = 80 + (mission_number - 1) * 16
        sspr(
            0,
            selected and sy or (sy - 48),
            button_wh.x,
            button_wh.y,
            button_xy1.x,
            button_xy1.y
        )

        -- draw button borders
        rect(
            button_xy1.x - 1,
            button_xy1.y - 1,
            button_xy2.x,
            button_xy2.y,
            selected and _color_7_white or _color_13_lavender
        )
        line(
            button_xy1.x - 1,
            button_xy2.y + 1,
            button_xy2.x,
            button_xy2.y + 1,
            _color_14_mauve
        )

        -- draw label
        print(
            "mission " .. mission_number,
            button_xy1.x,
            button_xy2.y + 4,
            selected and _color_7_white or _color_13_lavender
        )

        -- draw X button press incentive and its label
        if selected then
            print(
                "start",
                button_xy2.x - 28,
                button_xy2.y + 4,
                _color_7_white
            )
            sspr(
                114 + 7 * flr(2 * t() % 2),
                108,
                7,
                6,
                button_xy2.x - 7,
                button_xy2.y + 3
            )
        end
    end

    local function draw_ship()
        local button_xy, button_wh = mission_button_xy_wh(selected_mission)
        clip(button_xy.x, button_xy.y, button_wh.x, button_wh.y)

        palt(_color_0_black, false)
        palt(_color_11_transparent, true)
        ship_sprite._draw(ship_movement.xy)
        jet_sprite._draw(ship_movement.xy.plus(0, 8))
        palt()

        clip()
    end

    local function init_ship_movement()
        local button_xy, button_wh = mission_button_xy_wh(selected_mission)
        ship_movement = new_movement_to_target_factory {
            target_y = button_xy.minus(0, 10).y,
            frames = 20,
        }(button_xy.plus(-_gaox + button_wh.x / 2, button_wh.y - 6))
    end

    --

    local screen = {}

    function screen._init()
        music(0)

        high_score = dget(0)

        init_ship_movement()
    end

    function screen._update()
        if btnp(_button_up) then
            _sfx_play(_sfx_options_change)
            selected_mission = (selected_mission - 2) % _max_mission_number + 1
            init_ship_movement()
        end
        if btnp(_button_down) then
            _sfx_play(_sfx_options_change)
            selected_mission = selected_mission % _max_mission_number + 1
            init_ship_movement()
        end

        if btnp(_button_x) then
            _music_fade_out()
            _sfx_play(_sfx_options_confirm)
            proceed = true
        end

        ship_sprite._update()
        jet_sprite._update()

        if proceed then
            if ship_movement.has_finished() then
                fade_out._update()
            else
                ship_movement._update()
            end
        else
            fade_in._update()
        end
    end

    function screen._draw()
        cls(_color_1_darker_blue)

        print("shmup", 34, 10, _color_15_peach)

        -- TODO: polish it
        if high_score > 0 then
            print("high score", 10, 25, _color_6_light_grey)
            print(new_score(high_score).as_6_digits_text_with_extra_zero(), 70, 25, _color_9_dark_orange)
        end

        for i = 1, 3 do
            draw_mission_button(i)
        end
        draw_ship()

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
                score = 0,
            }
        end
    end

    return screen
end
