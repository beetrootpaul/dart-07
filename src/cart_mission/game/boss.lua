-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/boss.lua --
-- -- -- -- -- -- -- -- -- -- --
function new_boss(params)
    local on_bullets_spawned, on_entered_next_phase, on_damage, on_destroyed = params.on_bullets_spawned, params.on_entered_next_phase, params.on_damage, params.on_destroyed
    local boss_properties = _m_boss_properties()
    local phases = boss_properties.phases
    local boss_sprite_props_txt, flash_sprite_props_txt = _unpack_split(boss_properties.sprites_props_txt, "|")
    local boss_sprite, flash_sprite = new_static_sprite(boss_sprite_props_txt), new_static_sprite(flash_sprite_props_txt)
    local movement = new_movement_to_target_factory {
        target_x = _gawdb2,
        target_y = 20,
        frames = 180,
        easing_fn = _easing_easeoutquart
    }(_xy(_gawdb2, -120))
    -- DEBUG:
    --frames = 8,
    local current_phase_number, is_destroyed, flashing_after_damage_timer = 0, false, nil
    function collision_circles()
        local ccs = {}
        for cc_props in all(boss_properties.collision_circles_props) do
            add(ccs, {
                xy = movement.xy.plus(cc_props[2] or _xy_0_0),
                r = cc_props[1]
            })
        end
        return ccs
    end
    
    --
    local boss = {
        invincible_during_intro = true,
        health_max = boss_properties.health,
        health = boss_properties.health
    }
    function boss.has_finished()
        return is_destroyed
    end
    
    function boss.start_first_phase()
        current_phase_number = 1
        movement = phases[current_phase_number][5](movement.xy)
        boss.invincible_during_intro = false
    end
    
    boss.collision_circles = collision_circles
    function boss.take_damage(damage)
        boss.health = max(0, boss.health - damage)
        if boss.health > 0 then
            flashing_after_damage_timer = new_timer(4)
            on_damage()
        else
            is_destroyed = true
            on_destroyed(collision_circles(), phases[#phases][2])
        end
    end
    
    function boss._update()
        if current_phase_number > 0 and current_phase_number < #phases then
            if phases[current_phase_number + 1][1] >= boss.health / boss.health_max then
                on_entered_next_phase(collision_circles(), phases[current_phase_number][2])
                current_phase_number = current_phase_number + 1
                movement = phases[current_phase_number][5](movement.xy)
            end
        end
        movement._update()
        if current_phase_number > 0 then
            local current_phase = phases[current_phase_number]
            local bullet_fire_timer = current_phase[3] or new_fake_timer()
            bullet_fire_timer._update()
            if bullet_fire_timer.ttl <= 0 then
                bullet_fire_timer.restart()
                on_bullets_spawned(current_phase[4], movement)
            end
        end
        if flashing_after_damage_timer then
            if flashing_after_damage_timer.ttl <= 0 then
                flashing_after_damage_timer = nil
            else
                flashing_after_damage_timer._update()
            end
        end
    end
    
    function boss._draw()
        boss_sprite._draw(ceil(movement.xy.x), ceil(movement.xy.y))
        -- DEBUG:
        --if t() * 2 % 2 < 1 then
        if flashing_after_damage_timer and flashing_after_damage_timer.ttl > 0 then
            flash_sprite._draw(movement.xy)
        end
    end
    
    return boss
end
