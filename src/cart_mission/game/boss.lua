-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/boss.lua --
-- -- -- -- -- -- -- -- -- -- --

function new_boss(params)
    local boss_properties = params.boss_properties
    local intro_frames = params.intro_frames
    local intro_start_xy = params.intro_start_xy
    local start_xy = params.start_xy
    local on_bullets_spawned = params.on_bullets_spawned
    local on_entered_next_phase = params.on_entered_next_phase
    local on_destroyed = params.on_destroyed

    local phases = boss_properties.phases

    local movement = new_movement_to_target_factory {
        target_x = start_xy.x,
        target_y = start_xy.y,
        frames = intro_frames,
        easing_fn = _easing_easeoutquart,
    }(intro_start_xy)

    local current_phase_number = 0

    local invincible_during_intro = true

    local flashing_from_damage = false

    local is_destroyed = false

    --

    local boss = {
        health_max = boss_properties.health,
        health = boss_properties.health,
    }

    function boss.has_finished()
        return is_destroyed
    end

    function boss.start_first_phase()
        current_phase_number = 1
        movement = phases[current_phase_number].movement_factory(movement.xy)
        invincible_during_intro = false
    end

    function boss.collision_circles()
        return boss_properties.collision_circles(movement)
    end

    function boss.is_invincible_during_intro()
        return invincible_during_intro
    end

    function boss.take_damage()
        boss.health = boss.health - 1
        if boss.health > 0 then
            flashing_from_damage = true
        else
            is_destroyed = true
            on_destroyed(boss_properties.collision_circles(movement))
        end
    end

    function boss._update()
        if current_phase_number > 0 and current_phase_number < #phases then
            if phases[current_phase_number + 1].triggering_health_fraction >= boss.health / boss.health_max then
                current_phase_number = current_phase_number + 1
                on_entered_next_phase(boss_properties.collision_circles(movement))
                movement = phases[current_phase_number].movement_factory(movement.xy)
            end
        end

        movement._update()

        if current_phase_number > 0 then
            local current_phase = phases[current_phase_number]
            current_phase.bullet_fire_timer._update()
            if current_phase.bullet_fire_timer.ttl <= 0 then
                current_phase.bullet_fire_timer.restart()
                on_bullets_spawned(current_phase.spawn_bullets, movement)
            end
        end

        flashing_from_damage = false
    end

    function boss._draw()
        boss_properties.sprite._draw(movement.xy.ceil(), {
            flash_color = flashing_from_damage and _color_9_dark_orange or nil,
        })
    end

    return boss
end