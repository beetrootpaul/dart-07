-- -- -- -- -- -- -- -- -- --
-- cart_mission/boss.lua   --
-- -- -- -- -- -- -- -- -- --

-- TODO: make collision detection work only if at least 1px of the enemy is visible, not before

function new_boss(params)
    local boss_properties = params.boss_properties
    local on_bullets_spawned = params.on_bullets_spawned

    local health = boss_properties.health
    local sprite = boss_properties.sprite
    local collision_circles = boss_properties.collision_circles
    -- TODO: multiple complex movements
    local movement = boss_properties.movement
    local bullet_fire_timer = boss_properties.bullet_fire_timer
    local spawn_bullets = boss_properties.spawn_bullets

    local is_flashing_from_damage = false
    local is_destroyed = false

    --

    local boss = {
        health_max = health,
        health = health,
    }

    function boss.has_finished()
        return is_destroyed
    end

    function boss.collision_circles()
        return collision_circles()
    end

    function boss.take_damage()
        boss.health = boss.health - 1
        if boss.health > 0 then
            is_flashing_from_damage = true
        else
            is_destroyed = true
        end
    end

    function boss.move()
        movement.move()
    end

    function boss.advance_timers()
        bullet_fire_timer.advance()
        if bullet_fire_timer.ttl <= 0 then
            bullet_fire_timer.restart()
            on_bullets_spawned(spawn_bullets())
        end

        is_flashing_from_damage = false
    end

    -- TODO: multiple sprites with their own slight movement 
    function boss.draw()
        sprite.draw(movement.x, movement.y, {
            -- TODO: make it pure white?
            flash_color = is_flashing_from_damage and _color_9_dark_orange or nil,
        })
    end

    return boss
end