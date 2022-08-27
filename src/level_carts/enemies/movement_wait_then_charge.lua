-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/enemies/movement_wait_then_charge.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_wait_then_charge(start_x, start_y)
    local age = 0

    local movement = {
        x = start_x,
        y = start_y,
    }

    function movement.update()
        if age < 40 then
            movement.x = movement.x - 1
        else
            movement.x = movement.x - 3
        end
        age = age + 1
    end

    return movement
end

