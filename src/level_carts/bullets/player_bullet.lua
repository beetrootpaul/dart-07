-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/bullets/player_bullet.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_player_bullet(x, y)
    local is_destroyed = false

    local bullet_sprites = new_static_sprite {
        sprite_w = 6,
        sprite_h = 4,
        sprite_x = 0,
        sprite_y = 13,
    }

    return {
        has_finished = function()
            return is_destroyed or x > _gaw + _ts
        end,

        collision_circle = function()
            return {
                x = x + .5,
                y = y - .5,
                r = 2,
            }
        end,

        move = function()
            x = x + 3
        end,

        destroy = function()
            is_destroyed = true
        end,

        draw = function()
            bullet_sprites.draw(x, y)
        end,
    }
end

