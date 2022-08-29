-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/bullets/enemy_bullet.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_enemy_bullet(params)
    local x,y = params.x, params.y
    local angle = params.angle
    local base_speed_x = params.base_speed_x
    
    local is_destroyed = false

    local bullet_sprite = new_static_sprite {
        sprite_w = 4,
        sprite_h = 4,
        sprite_x = 0,
        sprite_y = 17,
    }

    return {
        has_finished = function()
            return is_destroyed or x < 0 - _ts or x > _gaw + _ts or y < _gaoy - _ts or y > _gaoy + _gah + _ts
        end,

        collision_circle = function()
            return {
                x = x - .5,
                y = y - .5,
                r = 2,
            }
        end,

        move = function()
            x = x + 2 * cos(angle) + base_speed_x
            y = y + 2 * sin(angle)
        end,

        destroy = function()
            is_destroyed = true
        end,

        draw = function()
            bullet_sprite.draw(x, y)
        end,
    }
end

