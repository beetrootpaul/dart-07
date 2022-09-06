-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- common/movement/movement_line_factory.lua    --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- angle: 0 = right, .25 = up, .5 = left, .75 = down
function new_movement_line_factory(params)
    return function(start_xy)
        local timer = params.frames and new_timer(params.frames) or new_fake_timer()
        
        local movement = {
            xy = start_xy,
            speed_xy = _xy(
                params.angled_speed * cos(params.angle),
                params.angled_speed * sin(params.angle) + (params.base_speed_y or 0)
            ),
        }

        function movement.has_finished()
            return timer.ttl <= 0
        end

        function movement._update()
            timer._update()
            movement.xy = movement.xy.plus(movement.speed_xy)
        end

        return movement
    end
end

