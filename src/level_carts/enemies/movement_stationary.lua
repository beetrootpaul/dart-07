-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/enemies/movement_stationary.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_stationary(start_x, start_y)
    local movement = {
        x = start_x,
        y = start_y,
        base_speed_x = -_scroll_per_frame
    }

    function movement.move()
        movement.x = movement.x + movement.base_speed_x
    end

    return movement
end

