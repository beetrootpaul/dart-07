-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/enemy_bullet_factory.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_enemy_bullet_factory(bullet_properties)
    return function(movement)
        local is_destroyed = false

        return {
            has_finished = function()
                return is_destroyed or _is_safely_outside_gameplay_area(movement.xy)
            end,

            collision_circle = function()
                return {
                    xy = movement.xy,
                    r = bullet_properties.collision_circle_r,
                }
            end,

            destroy = function()
                is_destroyed = true
            end,

            _update = function()
                movement._update()
            end,

            _draw = function()
                bullet_properties.bullet_sprite._draw(movement.xy)
            end,
        }
    end
end

