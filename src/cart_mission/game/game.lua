-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/game.lua --
-- -- -- -- -- -- -- -- -- -- --



local negative = {
    [0] = 7,
    [1] = 15,
    [2] = 11,
    [3] = 13,
    [4] = 4, --
    [5] = 5, -- 
    [6] = 14,
    [7] = 0,
    [8] = 10,
    [9] = 12,
    [10] = 8,
    [11] = 2,
    [12] = 9,
    [13] = 3,
    [14] = 6,
    [15] = 1,
}

function new_game(params)
    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)

    local player_bullets = {}
    local enemy_bullets = {}
    local enemies = {}
    local powerups = {}
    local explosions = {}

    local boss

    local player = new_player {
        on_bullets_spawned = function(bullets)
            for _, b in pairs(bullets) do
                add(player_bullets, b)
            end
        end,
        on_destroyed = function(collision_circle)
            -- TODO: explosion SFX
            add(explosions, new_explosion(collision_circle.xy, 1 * collision_circle.r))
            add(explosions, new_explosion(collision_circle.xy, 2 * collision_circle.r, 4 + flr(rnd(8))))
            add(explosions, new_explosion(collision_circle.xy, 3 * collision_circle.r, 12 + flr(rnd(8))))
        end,
    }

    local game = {
        player_health = params.health,
        boss_health = nil,
        boss_health_max = nil,
        triple_shot = params.triple_shot,
        fast_shoot = params.fast_shoot,
    }

    local function handle_player_damage()
        -- TODO: powerups retrieval after live lost?
        -- TODO: SFX
        game.triple_shot = false
        game.fast_shoot = false
        -- TODO: VFX of disappearing health segment
        game.player_health = game.player_health - 1
        player.take_damage(game.player_health)
    end

    local function handle_collisions()
        local player_cc = player.collision_circle()

        -- player vs powerups
        for _, powerup in pairs(powerups) do
            -- TODO: magnet?
            if not powerup.has_finished() then
                if _collisions.are_colliding(player_cc, powerup.collision_circle()) then
                    -- TODO: SFX
                    -- TODO: VFX on player
                    -- TODO: VFX on health status
                    powerup.pick()
                    if powerup.powerup_type == "h" then
                        if game.player_health < _health_max then
                            game.player_health = game.player_health + 1
                        else
                            -- TODO: increment score instead
                        end
                    elseif powerup.powerup_type == "t" then
                        game.triple_shot = true
                    elseif powerup.powerup_type == "f" then
                        game.fast_shoot = true

                        -- TODO NEXT: shock waves
                        -- TODO NEXT: max 4 shock waves
                    end
                end
            end
        end

        -- player bullets vs enemies + player vs enemies
        for _, enemy in pairs(enemies) do
            local enemy_cc = enemy.collision_circle()
            for __, player_bullet in pairs(player_bullets) do
                if not enemy.has_finished() and not player_bullet.has_finished() then
                    if _collisions.are_colliding(player_bullet.collision_circle(), enemy_cc) then
                        -- TODO: SFX
                        enemy.take_damage()
                        player_bullet.destroy()
                    end
                end
            end
            if not enemy.has_finished() and not player.is_invincible_after_damage() then
                if _collisions.are_colliding(player_cc, enemy_cc) then
                    -- TODO: SFX
                    enemy.take_damage()
                    handle_player_damage()
                end
            end
        end

        -- player bullets vs boss + player vs boss
        if boss then
            for _, boss_cc in pairs(boss.collision_circles()) do
                for __, player_bullet in pairs(player_bullets) do
                    if not boss.is_invincible_during_intro() and not boss.has_finished() and not player_bullet.has_finished() then
                        if _collisions.are_colliding(player_bullet.collision_circle(), boss_cc) then
                            -- TODO: SFX
                            boss.take_damage()
                            player_bullet.destroy()
                        end
                    end
                end
                if not boss.is_invincible_during_intro() and not boss.has_finished() and not player.is_invincible_after_damage() then
                    if _collisions.are_colliding(player_cc, boss_cc) then
                        -- TODO: SFX
                        boss.take_damage()
                        handle_player_damage()
                    end
                end
            end
        end

        -- player vs enemy bullets
        for _, enemy_bullet in pairs(enemy_bullets) do
            if not enemy_bullet.has_finished() and not player.is_invincible_after_damage() then
                if _collisions.are_colliding(enemy_bullet.collision_circle(), player_cc) then
                    handle_player_damage()
                    enemy_bullet.destroy()
                end
            end
        end
    end

    --

    function game.set_player_movement(left, right, up, down)
        player.set_movement(left, right, up, down)
    end

    function game.player_fire()
        player.fire {
            triple_shot = game.triple_shot,
            fast_shoot = game.fast_shoot,
        }
    end

    --

    function game.enter_enemies_phase()
        level.enter_phase_main()
    end

    function game.is_ready_to_enter_boss_phase()
        return level.has_scrolled_to_end() and #enemies <= 0 and #enemy_bullets <= 0 and #powerups <= 0
    end

    function game.enter_boss_phase()
        boss = new_boss {
            boss_properties = _m.boss_properties(),
            intro_frames = 180,
            intro_start_xy = _xy(_gaw / 2, -120),
            start_xy = _xy(_gaw / 2, 20, 20),
            on_bullets_spawned = function(bullets_fn, boss_movement)
                if player then
                    for _, b in pairs(bullets_fn(boss_movement, player.collision_circle())) do
                        add(enemy_bullets, b)
                    end
                end
            end,
            on_entered_next_phase = function(collision_circles)
                -- TODO: small explosions SFX
                for _, cc in pairs(collision_circles) do
                    add(explosions, new_explosion(cc.xy, .75 * cc.r))
                end
            end,
            on_destroyed = function(collision_circles)
                -- TODO: explosions SFX
                for _, cc in pairs(collision_circles) do
                    local xy, r = cc.xy, cc.r
                    add(explosions, new_explosion(xy, .8 * r))
                    add(explosions, new_explosion(xy, 1.4 * r, 4 + flr(rnd(44))))
                    add(explosions, new_explosion(xy, 1.8 * r, 12 + flr(rnd(36))))
                    add(explosions, new_explosion(xy, 3.5 * r, 30 + flr(rnd(18))))
                    add(explosions, new_explosion(xy, 5 * r, 50 + flr(rnd(6))))
                end
            end,
        }
    end

    function game.start_boss_fight()
        boss.start_first_phase()
    end

    function game.is_boss_defeated()
        -- assuming we won't call this method before boss fight has started
        return not boss
    end

    --

    function game._update()
        _flattened_for_each(
            { level },
            player_bullets,
            enemy_bullets,
            { player },
            enemies,
            { boss },
            powerups,
            explosions,
            function(game_object)
                game_object._update()
            end
        )

        if player then
            handle_collisions()
        end

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy {
                enemy_properties = _m.enemy_properties_for(enemy_to_spawn.enemy_map_marker),
                start_xy = enemy_to_spawn.xy,
                on_bullets_spawned = function(spawned_enemy_bullets_fn, enemy_movement)
                    if player then
                        for _, seb in pairs(spawned_enemy_bullets_fn(enemy_movement, player.collision_circle())) do
                            add(enemy_bullets, seb)
                        end
                    end
                end,
                on_destroyed = function(collision_circle, powerup_type)
                    -- TODO: explosion SFX
                    add(explosions, new_explosion(collision_circle.xy, 2 * collision_circle.r))
                    if powerup_type ~= "-" then
                        -- TODO NEXT: implement shock wave
                        add(powerups, new_powerup(collision_circle.xy, powerup_type))
                    end
                end,
            })
        end

        if boss then
            game.boss_health = boss.health
            game.boss_health_max = boss.health_max
        end
    end

    function game._draw()
        clip(_gaox, 0, _gaw, _gah)
        _flattened_for_each(
            { level },
            player_bullets,
            enemy_bullets,
            { player },
            enemies,
            { boss },
            powerups,
            explosions,
            function(game_object)
                game_object._draw()
            end
        )
        clip()

        local p_xy = player.collision_circle().xy
        local r_outer2 = 45 * 45
        local r_inner2 = 40 * 40
        local masks = {
            0x0000.000f,
            0x0000.00f0,
            0x0000.0f00,
            0x0000.f000,
            0x000f.0000,
            0x00f0.0000,
            0x0f00.0000,
            0xf000.0000,
        }
        for x = _gaox, _gaox + _gaw - 1, 8 do
            for y = 0, _gah - 1 do
                local dy = y - p_xy.y

                local offset = (x >> 1) + (y << 6)
                local c = peek4(0x6000 + offset)

                local result = 0
                for pos = 1, 7 do
                    local shift = pos * 4 - 20
                    local cp = (c & masks[pos]) >> shift
                    local dx = x + pos - 1 - p_xy.x - _gaox
                    local dist = dx * dx + dy * dy
                    if dist < r_outer2 and dist > r_inner2 then cp = negative[cp] end
                    result = result + (cp << shift)
                end

                -- TODO: describe poke4 in API file
                poke4(0x6000 + offset, result)
            end
        end

        -- DEBUG:
        --if boss then
        --    for _, boss_cc in pairs(boss.collision_circles()) do
        --        _collisions._debug_draw_collision_circle(boss_cc)
        --    end
        --end
        --_flattened_for_each(
        --    player_bullets,
        --    enemy_bullets,
        --    { player },
        --    enemies,
        --    powerups,
        --    function(game_object)
        --        _collisions._debug_draw_collision_circle(game_object.collision_circle())
        --    end
        --)
    end

    function game._post_draw()
        if player and player.has_finished() then
            player = nil
            player_bullets = {}
        end

        if boss and boss.has_finished() then
            boss = nil
            -- we assume here there are no enemies on a screen at the same time as boss is,
            -- therefore we can just remove all enemy bullets when boss is destroyed
            enemy_bullets = {}
        end

        _flattened_for_each(
            player_bullets,
            enemy_bullets,
            enemies,
            powerups,
            explosions,
            function(game_object, game_objects)
                if game_object.has_finished() then
                    del(game_objects, game_object)
                end
            end
        )
    end

    return game
end