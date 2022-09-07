-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/powerup.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: fancy animation
-- TODO: actions on pick up
-- TODO: magnet for an easier pickup?

function new_powerup(start_xy, powerup_type)
    local is_picked = false

    local sprite

    if powerup_type == "h" then
        sprite = new_static_sprite(9, 8, 119, 0)
    elseif powerup_type == "t" then
        sprite = new_static_sprite(9, 8, 119, 8)
    end

    local movement = new_movement_line_factory {
        angle = .75,
        angled_speed = .5,
    }(start_xy)

    local powerup = {
        powerup_type = powerup_type,
    }

    function powerup.has_finished()
        return is_picked or _is_safely_outside_gameplay_area(movement.xy)
    end

    function powerup.collision_circle()
        return {
            xy = movement.xy,
            r = 6,
        }
    end

    function powerup.pick()
        is_picked = true
    end

    function powerup._update()
        movement._update()
    end

    function powerup._draw()
        sprite._draw(movement.xy)
    end

    return powerup
end

