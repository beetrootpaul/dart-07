-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_sinusoidal.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_sinusoidal(params)
    local start_x = params.start_x
    local start_y = params.start_y

    local age = 0

    local function x()
        return start_x + 14 * sin(age / 60)
    end

    local movement = {
        x = x(),
        y = start_y,
        speed_x = x() - start_x,
        speed_y = 1,
    }

    -- TODO: make sure enemy cannot shoot when off screen
    function movement.move()
        movement.speed_x = x() - movement.x
        movement.x = movement.x + movement.speed_x
        movement.y = movement.y + movement.speed_y
        age = age + 1
    end

    return movement
end

