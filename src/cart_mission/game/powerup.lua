-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/powerup.lua --
-- -- -- -- -- -- -- -- -- -- -- --

-- TODO: fancy animation
-- TODO: magnet for an easier pickup?

function new_powerup(start_xy, powerup_type)
    local is_picked = false

    local function powerup_sprite(sprite_y)
        return new_static_sprite(9, 8, 119, sprite_y)
    end
    local sprites = {
        h = powerup_sprite(0),
        t = powerup_sprite(8),
        f = powerup_sprite(16),
        s = powerup_sprite(24),
    }

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
        sprites[powerup_type]._draw(movement.xy)
    end

    return powerup
end

