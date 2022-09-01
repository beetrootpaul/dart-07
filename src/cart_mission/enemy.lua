-- -- -- -- -- -- -- -- -- --
-- cart_mission/enemy.lua  --
-- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_properties = params.enemy_properties
    local on_bullets_spawned = params.on_bullets_spawned
    local on_powerup_spawned = params.on_powerup_spawned

    local health = enemy_properties.health
    local ship_sprite = enemy_properties.ship_sprite
    local collision_circle_r = enemy_properties.collision_circle_r
    local collision_circle_offset_y = enemy_properties.collision_circle_offset_y
    local movement = enemy_properties.movement
    local bullet_fire_timer = enemy_properties.bullet_fire_timer
    local spawn_bullets = enemy_properties.spawn_bullets
    local powerups_distribution = enemy_properties.powerups_distribution

    local is_flashing_from_damage = false
    local is_destroyed = false

    -- TODO: make collision detection work only if at least 1px of the enemy is visible, not before
    return {
        has_finished = function()
            return is_destroyed or movement.y > _gah + _ts
        end,

        collision_circle = function()
            return {
                x = movement.x - .5,
                y = movement.y - .5 + collision_circle_offset_y,
                r = collision_circle_r,
            }
        end,

        take_damage = function()
            health = health - 1
            if health > 0 then
                is_flashing_from_damage = true
            else
                is_destroyed = true
                local powerup_type = rnd(split(powerups_distribution))
                if powerup_type ~= "-" then
                    on_powerup_spawned(new_powerup {
                        x = movement.x,
                        y = movement.y,
                        powerup_type = powerup_type,
                    })
                end
            end
        end,

        move = function()
            movement.move()
        end,

        advance_timers = function()
            bullet_fire_timer.advance()
            if bullet_fire_timer.ttl <= 0 then
                bullet_fire_timer.restart()
                on_bullets_spawned(spawn_bullets())
            end

            is_flashing_from_damage = false
        end,

        draw = function()
            ship_sprite.draw(movement.x, movement.y, {
                -- TODO: make it pure white?
                flash_color = is_flashing_from_damage and _color_9_dark_orange or nil,
            })
        end,
    }
end