-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/enemies/enemy.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_type = params.enemy_type
    local start_x, start_y = params.start_x, params.start_y
    local on_bullet_fired = params.on_bullet_fired
    local on_powerup_spawned = params.on_powerup_spawned

    local health
    local movement
    local ship_sprite
    local collision_circle_r, collision_circle_offset_y
    local bullet_fire_timer, fire_bullets
    local powerups_distribution

    local is_destroyed = false

    if enemy_type == "sinusoidal" then
        health = 1
        movement = new_movement_sinusoidal(start_x, start_y)
        ship_sprite = new_static_sprite {
            sprite_w = 6,
            sprite_h = 7,
            sprite_x = 20,
            sprite_y = 10,
            transparent_color = _color_11_dark_green,
        }
        collision_circle_offset_y = 0
        collision_circle_r = 3
        bullet_fire_timer = new_timer(20)
        fire_bullets = function()
            on_bullet_fired(
                new_enemy_bullet {
                    x = movement.x,
                    y = movement.y,
                    angle = .75,
                    base_speed_y = movement.base_speed_y,
                }
            )
        end
        powerups_distribution = "-,-,-,-,-,-,-,-,-,-,-,-,-,-,a,a,t"
    elseif enemy_type == "wait_then_charge" then
        health = 3
        movement = new_movement_wait_then_charge(start_x, start_y)
        ship_sprite = new_static_sprite {
            sprite_w = 12,
            sprite_h = 9,
            sprite_x = 8,
            sprite_y = 10,
            transparent_color = _color_11_dark_green,
        }
        collision_circle_offset_y = -1
        collision_circle_r = 5
        bullet_fire_timer = new_fake_timer()
        fire_bullets = function()
        end
        powerups_distribution = "-,-,-,-,-,-,-,-,-,a,a,t"
    elseif enemy_type == "stationary" then
        health = 6
        movement = new_movement_stationary(start_x, start_y)
        ship_sprite = new_static_sprite {
            sprite_w = 16,
            sprite_h = 16,
            sprite_x = 38,
            sprite_y = 0,
            transparent_color = _color_11_dark_green,
        }
        collision_circle_offset_y = 0
        collision_circle_r = 8
        bullet_fire_timer = new_timer(30)
        fire_bullets = function()
            for i = 1, 7 do
                on_bullet_fired(
                    new_enemy_bullet {
                        x = movement.x,
                        y = movement.y,
                        angle = .25 + i / 8,
                        base_speed_y = movement.base_speed_y,
                    }
                )
            end
        end
        powerups_distribution = "-,-,-,a,a,t"
    end

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
            if health < 1 then
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