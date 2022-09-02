-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_sinusoidal.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_sinusoidal(params)
    local age = 0

    local function x()
        return params.start_x + 14 * sin(age / 60)
    end

    local movement = {
        x = x(),
        y = params.start_y,
        speed_x = x() - params.start_x,
        speed_y = 1,
    }

    function movement.has_reached_target()
        return false
    end

    -- TODO: make sure enemy cannot shoot when off screen
    function movement._update()
        movement.speed_x = x() - movement.x

        movement.x = movement.x + movement.speed_x
        movement.y = movement.y + movement.speed_y

        age = age + 1
    end

    return movement
end

