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
            local xy = movement.xy
            local outside = xy.x < -_ts or xy.x > _gaw + _ts or xy.y < -_ts or xy.y > _gah + _ts
            enemy_bullet.finished = enemy_bullet.finished or outside
        end

        function enemy_bullet._draw()
            bullet_properties.bullet_sprite._draw(movement.xy)
        end

        return enemy_bullet
    end
end

