-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_line.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: replace some usages with simple linear y movement

-- angle: 0 = right, .25 = up, .5 = left, .75 = down
function new_movement_line(params)
    local movement = {
        xy = params.start_xy,
        speed_xy = _xy(
            params.angled_speed * cos(params.angle),
            params.angled_speed * sin(params.angle) + params.base_speed_y
        ),
    }

    function movement.has_reached_target()
        return false
    end

    -- TODO: make sure enemy cannot shoot when off screen
    function movement._update()
        movement.xy = movement.xy.plus(movement.speed_xy)
    end

    return movement
end

