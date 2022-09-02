-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/powerup.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: fancy animation
-- TODO: actions on pick up
-- TODO: magnet for an easier pickup?

function new_powerup(params)
    local powerup_type = params.powerup_type
    local start_x, start_y = params.start_x, params.start_y

    local is_picked = false

    local sprite

    if powerup_type == "a" then
        sprite = new_static_sprite {
            sprite_w = 7,
            sprite_h = 8,
            sprite_x = 121,
            sprite_y = 0,
            transparent_color = _color_11_dark_green,
        }
    elseif powerup_type == "t" then
        sprite = new_static_sprite {
            sprite_w = 7,
            sprite_h = 8,
            sprite_x = 113,
            sprite_y = 0,
            transparent_color = _color_11_dark_green,
        }
    end

    local movement = new_movement_angled_line {
        start_x = start_x,
        start_y = start_y,
        base_speed_y = 0,
        angle = .75,
        angled_speed = 1,
    }

    local powerup = {
        powerup_type = powerup_type,
    }

    function powerup.has_finished()
        return is_picked or
            movement.x < _gaox - _ts or
            movement.x > _gaox + _gaw + _ts or
            movement.y < -_ts or
            movement.y > _gah + _ts
    end

    function powerup.collision_circle()
        return {
            x = movement.x - .5,
            y = movement.y - .5,
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
        sprite._draw(movement.x, movement.y)
    end

    return powerup
end

