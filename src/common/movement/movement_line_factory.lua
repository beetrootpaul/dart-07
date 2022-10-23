-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- common/movement/movement_line_factory.lua    --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- angle: 0 = right, .25 = up, .5 = left, .75 = down
function new_movement_line_factory(params)
    return function(start_xy)
        local angle = params.target_xy and _angle_between(start_xy, params.target_xy) or params.angle
        local angled_speed = params.angled_speed or 1
        local timer = params.frames and new_timer(params.frames) or new_fake_timer()
        local movement = {
            xy = start_xy,
            speed_xy = _xy(angled_speed * cos(angle), angled_speed * sin(angle) + (params.base_speed_y or 0))
        }
        function movement.has_finished()
            return timer.ttl <= 0
        end
        
        function movement._update()
            timer._update()
            if timer.ttl > 0 or params.continue_after_finished then
                movement.xy = movement.xy.plus(movement.speed_xy)
            end
        end
        
        return movement
    end
end
