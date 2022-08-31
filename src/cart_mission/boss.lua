-- -- -- -- -- -- -- -- -- --
-- cart_mission/boss.lua  --
-- -- -- -- -- -- -- -- -- --

function new_boss(params)
    local boss_properties = params.boss_properties
    local on_bullets_spawned = params.on_bullets_spawned

    local health = boss_properties.health
    local sprite = boss_properties.sprite
    local collision_circle_r = boss_properties.collision_circle_r
    local collision_circle_offset_y = boss_properties.collision_circle_offset_y
    -- TODO: mnultiple complex movements
    local movement = boss_properties.movement
    local bullet_fire_timer = boss_properties.bullet_fire_timer
    local spawn_bullets = boss_properties.spawn_bullets

    local is_destroyed = false

    -- TODO: make collision detection work only if at least 1px of the enemy is visible, not before
    return {
        has_finished = function()
            return is_destroyed
        end,

        -- TODO: multiple smaller collision circles 
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
        end,

        draw = function()
            -- TODO: multiple sprites with their own slight movement 
            sprite.draw(movement.x, movement.y)
        end,
    }
end