-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_to_target.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: use in hud
function new_movement_to_target(params)
    local start_x, start_y = params.start_x, params.start_y
    local target_x, target_y = params.target_x, params.target_y
    local timer = new_timer(params.frames)
    local easing_fn = params.easing_fn or _easing_linear

    local function x()
        return ceil(_easing_lerp(
            start_x,
            target_x,
            easing_fn(timer.passed_fraction())
        ))
    end
    local function y()
        return ceil(_easing_lerp(
            start_y,
            target_y,
            easing_fn(timer.passed_fraction())
        ))
    end

    local movement = {
        x = start_x,
        y = start_y,
        speed_x = x() - start_x,
        speed_y = y() - start_y,
    }

    function movement.has_reached_target()
        return timer.ttl <= 0
    end

    function movement._update()
        timer._update()

        movement.speed_x = x() - movement.x
        movement.speed_y = y() - movement.y

        movement.x = movement.x + movement.speed_x
        movement.y = movement.y + movement.speed_y
    end

    return movement
end

