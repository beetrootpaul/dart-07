-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/enemies/enemy.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_type = params.enemy_type
    local start_x, start_y = params.start_x, params.start_y
    local on_bullet_fired = params.on_bullet_fired
    local on_powerup_spawned = params.on_powerup_spawned

    local armor
    local movement
    local ship_sprite
    local collision_circle_r, collision_circle_offset_x
    local bullet_fire_timer, fire_bullets
    local powerups_distribution

    local is_destroyed = false

    if enemy_type == "sinusoidal" then
        armor = 1
        movement = new_movement_sinusoidal(start_x, start_y)
        ship_sprite = new_static_sprite {
            sprite_x = 18,
            sprite_y = 12,
            sprite_w = 7,
            sprite_h = 6,
            transparent_color = _color_11_dark_green,
        }
        collision_circle_offset_x = -1
        collision_circle_r = 3
        bullet_fire_timer = new_timer(20)
        fire_bullets = function()
            on_bullet_fired(
                new_enemy_bullet {
                    x = movement.x,
                    y = movement.y,
                    angle = .5,
                    base_speed_x = movement.base_speed_x,
                }
            )
        end
        powerups_distribution = "-,-,-,-,-,-,-,-,-,-,-,-,-,-,a,a,t"
    elseif enemy_type == "wait_then_charge" then
        armor = 3
        movement = new_movement_wait_then_charge(start_x, start_y)
        ship_sprite = new_static_sprite {
            sprite_x = 18,
            sprite_y = 0,
            sprite_w = 10,
            sprite_h = 12,
            transparent_color = _color_11_dark_green,
        }
        collision_circle_offset_x = 1
        collision_circle_r = 5
        bullet_fire_timer = new_fake_timer()
        fire_bullets = function()
        end
        powerups_distribution = "-,-,-,-,-,-,-,-,-,a,a,t"
    elseif enemy_type == "stationary" then
        armor = 6
        movement = new_movement_stationary(start_x, start_y)
        ship_sprite = new_static_sprite {
            sprite_x = 32,
            sprite_y = 0,
            sprite_w = 16,
            sprite_h = 16,
            transparent_color = _color_11_dark_green,
        }
        collision_circle_offset_x = 0
        collision_circle_r = 8
        bullet_fire_timer = new_timer(30)
        fire_bullets = function()
            for i = 1, 7 do
                on_bullet_fired(
                    new_enemy_bullet {
                        x = movement.x,
                        y = movement.y,
                        angle = i / 8,
                        base_speed_x = movement.base_speed_x,
                    }
                )
            end
        end
        powerups_distribution = "-,-,-,a,a,t"
    end

    -- TODO: make collision detection work only if at least 1px of the enemy is visible, not before
    return {
        has_finished = function()
            return is_destroyed or movement.x < -_ts
        end,

        collision_circle = function()
            return {
                x = movement.x - .5 + collision_circle_offset_x,
                y = movement.y - .5,
                r = collision_circle_r,
            }
        end,

        take_damage = function()
            armor = armor - 1
            if armor < 1 then
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
                fire_bullets()
            end
        end,

        draw = function()
            ship_sprite.draw(movement.x, movement.y)
        end,
    }
end