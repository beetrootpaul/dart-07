-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/bullets/player_bullet.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_player_bullet(x, y)
    local bullet_sprites = new_static_sprite {
        sprite_w = 6,
        sprite_h = 4,
        sprite_x = 0,
        sprite_y = 13,
    }

    return {
        has_finished = function()
            return x > _gaw + _ts
        end,

        move = function()
            x = x + 3
        end,

        draw = function()
            bullet_sprites.draw(x, y)
        end,
    }
end

