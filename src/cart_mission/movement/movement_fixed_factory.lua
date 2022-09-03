-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_fixed_factory.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

function new_movement_fixed_factory(params)
    params = params or {}
    
    return function(start_xy)
        local timer = params.frames and new_timer(params.frames) or new_fake_timer()

        local movement = {
            xy = start_xy,
            speed_xy = _xy(0, 0),
        }

        function movement.has_reached_target()
            return timer.ttl <= 0
        end

        function movement._update()
            timer._update()
        end

        return movement
    end
end

