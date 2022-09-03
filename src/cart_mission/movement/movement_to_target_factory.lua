-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_to_target_factory.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: use in hud
function new_movement_to_target_factory(params)
    local easing_fn = params.easing_fn or _easing_linear

    return function(start_xy)
        local timer = new_timer(params.frames)

        local function xy()
            return _xy(
                ceil(_easing_lerp(
                    start_xy.x,
                    params.target_xy.x,
                    easing_fn(timer.passed_fraction())
                )),
                ceil(_easing_lerp(
                    start_xy.y,
                    params.target_xy.y,
                    easing_fn(timer.passed_fraction())
                ))
            )
        end

        local movement = {
            xy = start_xy,
            speed_xy = xy().minus(start_xy),
        }

        function movement.has_reached_target()
            return timer.ttl <= 0
        end

        function movement._update()
            timer._update()
            movement.speed_xy = xy().minus(movement.xy)
            movement.xy = movement.xy.plus(movement.speed_xy)
        end

        return movement
    end
end

