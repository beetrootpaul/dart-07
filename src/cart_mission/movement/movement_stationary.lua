-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_stationary.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_stationary(params)
    local start_x = params.start_x
    local start_y = params.start_y

    local movement = {
        x = start_x,
        y = start_y,
        speed_x = 0,
        speed_y = _m.scroll_per_frame,
    }

    function movement.move()
        movement.y = movement.y + movement.speed_y
    end

    return movement
end

