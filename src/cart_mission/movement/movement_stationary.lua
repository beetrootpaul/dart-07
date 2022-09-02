-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_stationary.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_stationary(params)
    local movement = {
        x = params.start_x,
        y = params.start_y,
        speed_x = 0,
        speed_y = _m.scroll_per_frame,
    }

    function movement.has_reached_target()
        return false
    end

    function movement._update()
        movement.y = movement.y + movement.speed_y
    end

    return movement
end

