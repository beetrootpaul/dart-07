-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/enemies/movement_sinusoidal.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_sinusoidal(start_x, start_y)
    local age = 0

    local movement = {
        x = start_x,
        y = start_y,
    }

    function movement.update()
        movement.x = movement.x - 1
        movement.y = movement.y + 2 * sin(age / 60)
        age = age + 1
    end

    return movement
end

