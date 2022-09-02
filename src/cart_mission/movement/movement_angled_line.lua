-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_angled_line.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: replace some usages with simple linear y movement

-- angle: 0 = right, .25 = up, .5 = left, .75 = down
function new_movement_angled_line(params)
    local start_x = params.start_x
    local start_y = params.start_y
    local base_speed_y = params.base_speed_y
    local angle = params.angle
    local angled_speed = params.angled_speed

    local movement = {
        x = start_x,
        y = start_y,
        speed_x = angled_speed * cos(angle),
        speed_y = angled_speed * sin(angle) + base_speed_y,
    }

    -- TODO: make sure enemy cannot shoot when off screen
    function movement._update()
        movement.x = movement.x + movement.speed_x
        movement.y = movement.y + movement.speed_y
    end

    return movement
end

