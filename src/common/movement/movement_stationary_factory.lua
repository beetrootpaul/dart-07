-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- common/movement/movement_stationary_factory.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_stationary_factory()
    return function(start_xy)
        local movement = {
            xy = start_xy,
            speed_xy = _xy(0, _m.scroll_per_frame),
        }

        function movement.has_finished()
            return false
        end

        function movement._update()
            movement.xy = movement.xy.plus(movement.speed_xy)
        end

        return movement
    end
end

