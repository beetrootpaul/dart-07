-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/enemy_bullet.lua --
-- -- -- -- -- -- -- -- -- -- -- --

function new_enemy_bullet(bullet_properties)
    local bullet_sprite = bullet_properties.bullet_sprite
    local collision_circle_r = bullet_properties.collision_circle_r
    local movement = bullet_properties.movement

    local is_destroyed = false

    return {
        has_finished = function()
            return is_destroyed or
                movement.x < _gaox - _ts or
                movement.x > _gaox + _gaw + _ts or
                movement.y < -_ts or
                movement.y > _gah + _ts
        end,

        collision_circle = function()
            return {
                x = movement.x - .5,
                y = movement.y - .5,
                r = collision_circle_r,
            }
        end,

        move = function()
            movement.move()
        end,

        destroy = function()
            is_destroyed = true
        end,

        draw = function()
            bullet_sprite.draw(movement.x, movement.y)
        end,
    }
end

