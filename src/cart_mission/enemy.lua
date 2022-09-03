-- -- -- -- -- -- -- -- -- --
-- cart_mission/enemy.lua  --
-- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_properties = params.enemy_properties
    local start_xy = params.start_xy
    local on_bullets_spawned = params.on_bullets_spawned
    local on_powerup_spawned = params.on_powerup_spawned

    local health = enemy_properties.health
    local movement = enemy_properties.movement_factory(start_xy)
    local bullet_fire_timer = enemy_properties.bullet_fire_timer

    local is_flashing_from_damage = false
    local is_destroyed = false

    return {
        has_finished = function()
            return is_destroyed or movement.xy.y > _gah + _ts
        end,

        collision_circle = function()
            return {
                xy = movement.xy.plus(-.5, -.5 + enemy_properties.collision_circle_offset_y),
                r = enemy_properties.collision_circle_r,
            }
        end,

        take_damage = function()
            health = health - 1
            if health > 0 then
                is_flashing_from_damage = true
            else
                is_destroyed = true
                local powerup_type = rnd(split(enemy_properties.powerups_distribution))
                if powerup_type ~= "-" then
                    on_powerup_spawned(new_powerup {
                        start_xy = movement.xy,
                        powerup_type = powerup_type,
                    })
                end
            end
        end,

        _update = function()
            movement._update()

            bullet_fire_timer._update()
            if bullet_fire_timer.ttl <= 0 then
                bullet_fire_timer.restart()
                on_bullets_spawned(enemy_properties.spawn_bullets(movement))
            end

            is_flashing_from_damage = false
        end,

        _draw = function()
            enemy_properties.ship_sprite._draw(movement.xy, {
                -- TODO: make it pure white?
                flash_color = is_flashing_from_damage and _color_9_dark_orange or nil,
            })
        end,
    }
end