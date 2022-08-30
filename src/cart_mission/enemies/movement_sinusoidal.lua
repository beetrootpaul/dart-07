-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/enemies/movement_sinusoidal.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_sinusoidal(start_x, start_y)
    local age = 0

    local movement = {
        x = start_x,
        y = start_y,
        base_speed_y = 1,
    }

    -- TODO: make sure enemy cannot shoot when off screen
    function movement.move()
        movement.x = start_x + 14 * sin(age / 60)
        movement.y = movement.y + movement.base_speed_y
        age = age + 1
    end

    return movement
end

