-- -- -- -- -- -- -- -- -- --
-- cart_mission/boss.lua   --
-- -- -- -- -- -- -- -- -- --

-- TODO: make collision detection work only if at least 1px of the enemy is visible, not before

function new_boss(params)
    local boss_properties = params.boss_properties
    local intro_frames = params.intro_frames
    local intro_start_y = params.intro_start_y
    local on_bullets_spawned = params.on_bullets_spawned or _noop

    local health = boss_properties.health
    local sprite = boss_properties.sprite
    local collision_circles = boss_properties.collision_circles
    local bullet_fire_timer = boss_properties.bullet_fire_timer
    local spawn_bullets = boss_properties.spawn_bullets

    -- TODO: multiple complex sequence of movements

    local movement = new_movement_to_target {
        start_x = boss_properties.movement.x,
        start_y = intro_start_y,
        target_x = boss_properties.movement.x,
        target_y = boss_properties.movement.y,
        frames = intro_frames,
        easing_fn = _easing_easeoutquart,
    }

    local is_flashing_from_damage = false
    local is_destroyed = false

    --

    local boss = {
        health_max = health,
        health = health,
    }

    function boss.set_on_bullets_spawned(callback)
        on_bullets_spawned = callback
    end

    function boss.has_finished()
        return is_destroyed
    end

    function boss.enter_phase_main()
        movement = boss_properties.movement
    end

    function boss.collision_circles()
        return collision_circles(movement)
    end

    function boss.take_damage()
        boss.health = boss.health - 1
        if boss.health > 0 then
            is_flashing_from_damage = true
        else
            is_destroyed = true
        end
    end

    function boss._update(p)
        p = p or {}

        movement._update()

        if not p.no_fight then
            bullet_fire_timer._update()
            if bullet_fire_timer.ttl <= 0 then
                bullet_fire_timer.restart()
                on_bullets_spawned(spawn_bullets(movement))
            end
        end

        is_flashing_from_damage = false
    end

    -- TODO: multiple sprites with their own slight movement 
    function boss._draw()
        sprite._draw(movement.x, movement.y, {
            -- TODO: make it pure white?
            flash_color = is_flashing_from_damage and _color_9_dark_orange or nil,
        })
    end

    return boss
end