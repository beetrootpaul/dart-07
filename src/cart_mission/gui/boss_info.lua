-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/boss_info.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: better boss info GUI
-- TODO NEXT: boss name

function new_boss_info(params)
    local rounding_fn = "ceil"
    local movement = new_movement_sequence_factory {
        sequence = {
            new_movement_to_target_factory {
                frames = params.slide_in_frames,
                target_y = _gah / 2,
                easing_fn = _easing_easeoutquart,
                on_finished = function()
                    rounding_fn = "flr"
                end,
            },
            new_movement_fixed_factory {
                frames = params.present_frames,
            },
            new_movement_to_target_factory {
                frames = params.slide_out_frames,
                target_y = _gah + 1,
                easing_fn = _easing_easeinquart,
            },
        },
    }(_xy(_gaox, -1))

    return {
        _update = function()
            movement._update()
        end,

        _draw = function()
            clip(_gaox, 0, _gaw, _gah)

            local x, y = movement.xy[rounding_fn]().x, movement.xy[rounding_fn]().y
            for dx = -1, 1 do
                for dy = -1, 1 do
                    print("boss", x + 10 + dx, y - 7 + dy, _color_8_red)
                end
            end
            print("boss", x + 10, y - 7, _m.bg_color)
            rectfill(x, y, x + _gaw - 1, y, _color_8_red)

            clip()
        end,
    }
end