-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/enemies/movement_stationary.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_stationary(start_x, start_y)
    local movement = {
        x = start_x,
        y = start_y,
    }

    function movement.move()
        movement.x = movement.x - _ts * _distance_scroll_per_frame
    end

    return movement
end

