-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/powerup.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: fancy animation
-- TODO: actions on pick up
-- TODO: magnet for an easier pickup?

function new_powerup(params)
    local powerup_type = params.powerup_type
    local start_xy = params.start_xy

    local is_picked = false

    local sprite

    if powerup_type == "a" then
        sprite = new_static_sprite(7, 8, 121, 0, {
            transparent_color = _color_11_dark_green,
        })
    elseif powerup_type == "t" then
        sprite = new_static_sprite(7, 8, 113, 0, {
            transparent_color = _color_11_dark_green,
        })
    end

    local movement = new_movement_line_factory {
        base_speed_y = 0,
        angle = .75,
        angled_speed = 1,
    }(start_xy)

    local powerup = {
        powerup_type = powerup_type,
    }

    function powerup.has_finished()
        return is_picked or
            movement.xy.x < _gaox - _ts or
            movement.xy.x > _gaox + _gaw + _ts or
            movement.xy.y < -_ts or
            movement.xy.y > _gah + _ts
    end

    function powerup.collision_circle()
        return {
            xy = movement.xy.plus(-.5, -.5),
            r = 5,
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

