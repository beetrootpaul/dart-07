-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/enemy_bullet_factory.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_enemy_bullet_factory(bullet_properties)
    return function(movement)
        local enemy_bullet = {
            finished = false,
        }

        function enemy_bullet.collision_circle()
            return {
                xy = movement.xy,
                r = bullet_properties.collision_circle_r,
            }
        end

        function enemy_bullet.destroy()
            enemy_bullet.finished = true
        end

        function enemy_bullet._update()
            movement._update()
            enemy_bullet.finished = enemy_bullet.finished or _is_safely_outside_gameplay_area(movement.xy)
        end

        function enemy_bullet._draw()
            bullet_properties.bullet_sprite._draw(movement.xy)
        end

        return enemy_bullet
    end
end

