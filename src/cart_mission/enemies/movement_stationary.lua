-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/enemies/movement_stationary.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_stationary(start_x, start_y)
    local movement = {
        x = start_x,
        y = start_y,
        base_speed_y = _scroll_per_frame
    }

    function movement.move()
        movement.y = movement.y + movement.base_speed_y
    end

    return movement
end

