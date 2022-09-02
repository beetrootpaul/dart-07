-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_angled_line.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: replace some usages with simple linear y movement

-- angle: 0 = right, .25 = up, .5 = left, .75 = down
function new_movement_angled_line(params)
    local movement = {
        x = params.start_x,
        y = params.start_y,
        speed_x = params.angled_speed * cos(params.angle),
        speed_y = params.angled_speed * sin(params.angle) + params.base_speed_y,
    }

    function movement.has_reached_target()
        return false
    end

    -- TODO: make sure enemy cannot shoot when off screen
    function movement._update()
        movement.x = movement.x + movement.speed_x
        movement.y = movement.y + movement.speed_y
    end

    return movement
end

