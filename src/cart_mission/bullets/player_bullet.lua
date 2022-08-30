-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/bullets/player_bullet.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_player_bullet(x, y)
    local is_destroyed = false

    local bullet_sprite = new_static_sprite {
        sprite_w = 4,
        sprite_h = 6,
        sprite_x = 4,
        sprite_y = 12,
    }

    return {
        has_finished = function()
            return is_destroyed or y < -_ts
        end,

        collision_circle = function()
            return {
                x = x - .5,
                y = y - 1.5,
                r = 2,
            }
        end,

        move = function()
            y = y - 5
        end,

        destroy = function()
            is_destroyed = true
        end,

        draw = function()
            bullet_sprite.draw(x, y)
        end,
    }
end

