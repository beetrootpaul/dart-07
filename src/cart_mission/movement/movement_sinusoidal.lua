-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_sinusoidal.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_sinusoidal(params)
    local age = 0

    local function x()
        return params.start_xy.x + 14 * sin(age / 60)
    end

    local movement = {
        xy = params.start_xy.set_x(x()),
        speed_xy = _xy(
            x() - params.start_xy.x,
            1
        )
    }

    function movement.has_reached_target()
        return false
    end

    -- TODO: make sure enemy cannot shoot when off screen
    function movement._update()
        movement.speed_xy = movement.speed_xy.set_x(x() - movement.xy.x)
        movement.xy = movement.xy.plus(movement.speed_xy)
        age = age + 1
    end

    return movement
end

