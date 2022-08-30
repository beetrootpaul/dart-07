-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/enemies/movement_wait_then_charge.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_wait_then_charge(start_x, start_y)
    local age = 0

    local movement = {
        x = start_x,
        y = start_y,
        base_speed_x = -1,
    }

    function movement.move()
        if age >= 40 then
            movement.base_speed_x = -3
        end
        movement.x = movement.x + movement.base_speed_x
        age = age + 1
    end

    return movement
end

