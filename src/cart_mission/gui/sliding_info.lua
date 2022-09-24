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
            target_y = _gah + 18,
            easing_fn = _easing_easeinquart,
        },
    }(_xy(_gaox, -18))

    return {
        has_finished = movement.has_finished,

        _update = movement._update,

        _draw = function()
            local xy = movement.xy[rounding_fn]()
            local x, y = xy.x, xy.y
            if params.text_1 then
                _centered_print(params.text_1, y - 17, _m_bg_color, params.main_color)
            end
            _centered_print(params.text_2, y - 8, _m_bg_color, params.main_color)
            line(x, y, x + _gaw - 1, y, params.main_color)
        end,
    }
end