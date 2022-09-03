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
                movement.xy.x < _gaox - _ts or
                movement.xy.x > _gaox + _gaw + _ts or
                movement.xy.y < -_ts or
                movement.xy.y > _gah + _ts
        end,

        collision_circle = function()
            return {
                xy = movement.xy.plus(-.5, -.5),
                r = collision_circle_r,
            }
        end,

        destroy = function()
            is_destroyed = true
        end,

        _update = function()
            movement._update()
        end,

        _draw = function()
            bullet_sprite._draw(movement.xy)
        end,
    }
end

