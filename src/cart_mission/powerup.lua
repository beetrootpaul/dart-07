-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/powerup.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: fancy animation
-- TODO: actions on pick up
-- TODO: magnet for an easier pickup?

function new_powerup(params)
    local powerup_type = params.powerup_type
    local x, y = params.x, params.y

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

    local powerup = {
        powerup_type = powerup_type,
    }

    function powerup.has_finished()
        return is_picked or
            x < _gaox - _ts or
            x > _gaox + _gaw + _ts or
            y < -_ts or
            y > _gah + _ts
    end

    function powerup.collision_circle()
        return {
            x = x - .5,
            y = y - .5,
            r = 5,
        }
    end

    function powerup.pick()
        is_picked = true
    end

    function powerup.move()
        y = y + 1
    end

    function powerup.draw()
        sprite.draw(x, y)
    end

    return powerup
end

