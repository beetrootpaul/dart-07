-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/float.lua   --
-- -- -- -- -- -- -- -- -- -- -- --
function new_float(start_xy, score)
    local movement = new_movement_line_factory {
        angle = .25,
        angled_speed = .5,
        frames = 45
    }(start_xy)
    return {
        has_finished = movement.has_finished,
        _update = movement._update,
        _draw = function()
            local xy = movement.xy
            _centered_print(score .. "0", xy.y, _color_7_white, nil, xy.x)
        end
    }
end
