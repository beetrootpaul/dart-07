-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_wait_then_charge.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_wait_then_charge(params)
    -- TODO: use timer instead
    local age = 0

    local movement = {
        x = params.start_x,
        y = params.start_y,
        speed_x = 0,
        speed_y = 1,
    }

    function movement.has_reached_target()
        return false
    end

    function movement._update()
        if age >= 40 then
            movement.speed_y = 3
        end
        movement.y = movement.y + movement.speed_y
        age = age + 1
    end

    return movement
end

