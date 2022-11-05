-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/powerup.lua --
-- -- -- -- -- -- -- -- -- -- -- --
function new_powerup(start_xy, powerup_type)
    local is_picked = false
    local sprites = {
        h = new_static_sprite "9,8,18,16",
        m = new_static_sprite "9,8,9,16",
        f = new_static_sprite "9,8,9,24",
        t = new_static_sprite "9,8,18,24",
        s = new_static_sprite "9,8,27,24"
    }
    local movement = new_movement_line_factory {
        angle = .75,
        angled_speed = .5
    }(start_xy)
    local powerup = {
        powerup_type = powerup_type,
        _update = movement._update
    }
    function powerup.has_finished()
        return is_picked or _is_safely_outside_gameplay_area(movement.xy)
    end

    function powerup.collision_circle()
        return {
            xy = movement.xy,
            r = 7
        }
    end

    function powerup.pick()
        is_picked = true
    end

    function powerup._draw()
        sprites[powerup_type]._draw(movement.xy)
    end

    return powerup
end
