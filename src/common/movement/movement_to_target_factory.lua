-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- common/movement/movement_to_target_factory.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_to_target_factory(params)
    local easing_fn = params.easing_fn or _easing_linear

    return function(start_xy)
        local timer = new_timer(params.frames)
        local on_finished = params.on_finished or nil

        local function xy()
            return _xy(
                _easing_lerp(
                    start_xy.x,
                    params.target_x or start_xy.x,
                    easing_fn(timer.passed_fraction())
                ),
                _easing_lerp(
                    start_xy.y,
                    params.target_y or start_xy.y,
                    easing_fn(timer.passed_fraction())
                )
            )
        end

        local movement = {
            xy = start_xy,
            speed_xy = xy().minus(start_xy),
        }

        function movement.has_finished()
            return timer.ttl <= 0
        end

        function movement._update()
            timer._update()
            if on_finished and timer.ttl <= 0 then
                on_finished()
                on_finished = nil
            end
            movement.speed_xy = xy().minus(movement.xy)
            movement.xy = movement.xy.plus(movement.speed_xy)
        end

        return movement
    end
end

