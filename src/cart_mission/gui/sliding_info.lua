-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/sliding_info.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_sliding_info(params)
    local rounding_fn = "ceil"
    local movement = new_movement_sequence_factory {
        new_movement_fixed_factory {
            frames = params.wait_frames or 0,
        },
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
    }(_xy(_gaox, -1))

    return {
        has_finished = movement.has_finished,

        _update = movement._update,

        _draw = function()
            clip(_gaox, 0, _gaw, _gah)

            local x, y = movement.xy[rounding_fn]().x, movement.xy[rounding_fn]().y
            _outlined_print(params.text_1, x + 10, y - 13, _m.bg_color, _color_8_red)
            _outlined_print(params.text_2, x + 10, y - 7, _m.bg_color, _color_8_red)
            line(x, y, x + _gaw - 1, y, _color_8_red)

            clip()
        end,
    }
end