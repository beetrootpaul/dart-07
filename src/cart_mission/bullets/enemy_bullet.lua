-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/bullets/enemy_bullet.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_enemy_bullet(params)
    local x, y = params.x, params.y
    local angle = params.angle
    local base_speed_y = params.base_speed_y

    local is_destroyed = false

    local bullet_sprite = new_static_sprite {
        sprite_w = 4,
        sprite_h = 4,
        sprite_x = 0,
        sprite_y = 12,
    }

    return {
        has_finished = function()
            return is_destroyed or
                x < _gaox - _ts or
                x > _gaox + _gaw + _ts or
                y < -_ts or
                y > _gah + _ts
        end,

        collision_circle = function()
            return {
                x = x - .5,
                y = y - .5,
                r = 2,
            }
        end,

        move = function()
            x = x + 2 * cos(angle)
            y = y + 2 * sin(angle) + base_speed_y
        end,

        destroy = function()
            is_destroyed = true
        end,

        draw = function()
            bullet_sprite.draw(x, y)
        end,
    }
end

