-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_wait_then_charge.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_wait_then_charge(params)
    local start_x = params.start_x
    local start_y = params.start_y

    local age = 0

    local movement = {
        x = start_x,
        y = start_y,
        speed_x = 0,
        speed_y = 1,
    }

    function movement.move()
        if age >= 40 then
            movement.speed_y = 3
        end
        movement.y = movement.y + movement.speed_y
        age = age + 1
    end

    return movement
end

