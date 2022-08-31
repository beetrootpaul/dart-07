-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/new_movement_fixed.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_fixed(params)
    local start_x = params.start_x
    local start_y = params.start_y

    local movement = {
        x = start_x,
        y = start_y,
        speed_x = 0,
        speed_y = 0,
    }

    function movement.move()
        -- do nothing
    end

    return movement
end

