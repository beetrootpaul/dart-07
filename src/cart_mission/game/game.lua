-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/game.lua --
-- -- -- -- -- -- -- -- -- -- --

function new_game(params)
    local game = {
        health = params.health,
        shockwave_charges = params.shockwave_charges,
        boss_health = nil,
        boss_health_max = nil,
        triple_shot = params.triple_shot,
        fast_shoot = params.fast_shoot,
    }

    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)

    local player_bullets, enemy_bullets, enemies, powerups, explosions, shockwaves = {}, {}, {}, {}, {}, {}

    local shockwave_enemy_hits = {}

    local boss

    local player = new_player {
        on_bullets_spawned = function(bullets)
            if game.triple_shot then
                sfx(_sfx_player_triple_shoot, 3)
            else
                sfx(_sfx_player_shoot, 3)
            end
            for _, b in pairs(bullets) do
                add(player_bullets, b)
            end
        end,
        on_shockwave_triggered = function(shockwave)
            sfx(_sfx_player_shockwave, 3)
            add(shockwaves, shockwave)
        end,
        on_damaged = function()
            sfx(_sfx_damage_player, 3)
        end,
        on_destroyed = function(collision_circle)
            sfx(_sfx_destroy_player, 3)
            add(explosions, new_explosion(collision_circle.xy, 1 * collision_circle.r))
            add(explosions, new_explosion(collision_circle.xy, 2 * collision_circle.r, 4 + flr(rnd(8))))
            add(explosions, new_explosion(collision_circle.xy, 3 * collision_circle.r, 12 + flr(rnd(8))))
        end,
    }

    --

    local function handle_player_damage()
        game.triple_shot = false
        game.fast_shoot = false
        game.health = game.health - 1
        player.take_damage(game.health)
    end

    local function handle_powerup(powerup)
        if powerup.powerup_type == "h" then
            if game.health < _health_max then
                sfx(_sfx_powerup_heart, 3)
                game.health = game.health + 1
            else
                sfx(_sfx_powerup_no_effect, 3)
            end
        elseif powerup.powerup_type == "t" then
            if game.triple_shot then
                sfx(_sfx_powerup_no_effect, 3)
            else
                sfx(_sfx_powerup_triple_shot, 3)
                game.triple_shot = true
            end
        elseif powerup.powerup_type == "f" then
            if game.fast_shoot then
                sfx(_sfx_powerup_no_effect, 3)
            else
                sfx(_sfx_powerup_fast_shot, 3)
                game.fast_shoot = true
            end
        elseif powerup.powerup_type == "s" then
            if game.shockwave_charges < _shockwave_charges_max then
                sfx(_sfx_powerup_shockwave, 3)
                game.shockwave_charges = game.shockwave_charges + 1
            else
                sfx(_sfx_powerup_no_effect, 3)
            end
        end
    end

    local function handle_collisions()
        local player_cc = player.collision_circle()

        -- player vs powerups
        for _, powerup in pairs(powerups) do
            if not powerup.has_finished() then
                if _collisions.are_colliding(player_cc, powerup.collision_circle()) then
                    powerup.pick()
                    handle_powerup(powerup)
                end
            end
        end

        -- shockwaves vs enemies + player bullets vs enemies + player vs enemies
        for _, enemy in pairs(enemies) do
            local enemy_cc = enemy.collision_circle()
            for _, shockwave in pairs(shockwaves) do
                local combined_id = shockwave.id .. "-" .. enemy.id
                shockwave_enemy_hits[combined_id] = shockwave_enemy_hits[combined_id] or 0
                if not enemy.has_finished() and not shockwave.has_finished() and shockwave_enemy_hits[combined_id] < 8 then
                    if _collisions.are_colliding(shockwave.collision_circle(), enemy_cc, {
                        ignore_gameplay_area_check = true,
                    }) then
                        enemy.take_damage(2)
                        shockwave_enemy_hits[combined_id] = shockwave_enemy_hits[combined_id] + 1
                    end
                end
            end
            for __, player_bullet in pairs(player_bullets) do
                if not enemy.has_finished() and not player_bullet.has_finished() then
                    if _collisions.are_colliding(player_bullet.collision_circle(), enemy_cc) then
                        enemy.take_damage(1)
                        player_bullet.destroy()
                    end
                end
            end
            if not enemy.has_finished() and not player.is_invincible_after_damage() then
                if _collisions.are_colliding(player_cc, enemy_cc) then
                    enemy.take_damage(1)
                    handle_player_damage()
                end
            end
        end

        -- shockwaves vs boss + player bullets vs boss + player vs boss
        if boss and not boss.is_invincible_during_intro() then
            for _, boss_cc in pairs(boss.collision_circles()) do
                for _, shockwave in pairs(shockwaves) do
                    local combined_id = shockwave.id .. "-boss"
                    shockwave_enemy_hits[combined_id] = shockwave_enemy_hits[combined_id] or 0
                    if not boss.has_finished() and not shockwave.has_finished() and shockwave_enemy_hits[combined_id] < 8 then
                        if _collisions.are_colliding(shockwave.collision_circle(), boss_cc, {
                            ignore_gameplay_area_check = true,
                        }) then
                            boss.take_damage(2)
                            shockwave_enemy_hits[combined_id] = shockwave_enemy_hits[combined_id] + 1
                        end
                    end
                end
                for __, player_bullet in pairs(player_bullets) do
                    if not boss.has_finished() and not player_bullet.has_finished() then
                        if _collisions.are_colliding(player_bullet.collision_circle(), boss_cc) then
                            boss.take_damage(1)
                            player_bullet.destroy()
                        end
                    end
                end
                if not boss.has_finished() and not player.is_invincible_after_damage() then
                    if _collisions.are_colliding(player_cc, boss_cc) then
                        boss.take_damage(1)
                        handle_player_damage()
                    end
                end
            end
        end

        -- shockwaves vs enemy bullets + player vs enemy bullets
        for _, enemy_bullet in pairs(enemy_bullets) do
            local enemy_bullet_cc = enemy_bullet.collision_circle()
            for _, shockwave in pairs(shockwaves) do
                if not enemy_bullet.has_finished() and not shockwave.has_finished() then
                    if _collisions.are_colliding(shockwave.collision_circle(), enemy_bullet_cc) then
                        enemy_bullet.destroy()
                    end
                end
            end
            if not enemy_bullet.has_finished() and not player.is_invincible_after_damage() then
                if _collisions.are_colliding(enemy_bullet_cc, player_cc) then
                    handle_player_damage()
                    enemy_bullet.destroy()
                end
            end
        end
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
            on_damage = function()
                sfx(_sfx_damage_boss, 3)
            end,
            on_entered_next_phase = function(collision_circles)
                sfx(_sfx_destroy_boss_phase, 3)
                for _, cc in pairs(collision_circles) do
                    add(explosions, new_explosion(cc.xy, .75 * cc.r))
                end
            end,
            on_destroyed = function(collision_circles)
                sfx(_sfx_destroy_boss_final_1, 3)
                for _, cc in pairs(collision_circles) do
                    local xy, r = cc.xy, cc.r
                    add(explosions, new_explosion(xy, .8 * r))
                    add(explosions, new_explosion(xy, 1.4 * r, 4 + flr(rnd(44))))
                    add(explosions, new_explosion(xy, 1.8 * r, 12 + flr(rnd(36)), function()
                        sfx(_sfx_destroy_boss_final_2, 3)
                    end))
                    add(explosions, new_explosion(xy, 3.5 * r, 30 + flr(rnd(18))))
                    add(explosions, new_explosion(xy, 5 * r, 50 + flr(rnd(6)), function()
                        sfx(_sfx_destroy_boss_final_3, 3)
                    end))
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
        if player then
            player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))
            if btn(_button_x) then
                player.fire {
                    triple_shot = game.triple_shot,
                    fast_shoot = game.fast_shoot,
                }
            end
            if btnp(_button_o) then
                if game.shockwave_charges > 0 then
                    game.shockwave_charges = game.shockwave_charges - 1
                    player.trigger_shockwave()
                else
                end
            end
        end

        _flattened_for_each(
            { level },
            shockwaves,
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
                on_damaged = function(collision_circle)
                    sfx(_sfx_damage_enemy, 3)
                    add(explosions, new_explosion(collision_circle.xy, .5 * collision_circle.r))
                end,
                on_destroyed = function(collision_circle, powerup_type)
                    sfx(_sfx_destroy_enemy, 3)
                    add(explosions, new_explosion(collision_circle.xy, 2.5 * collision_circle.r))
                    if powerup_type ~= "-" then
                        sfx(_sfx_powerup_spawned, 3)
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
            enemies, -- some enemies are placed on a ground and have collision circle smaller than a sprite, therefore have to be drawn before a player and bullets
            { boss },
            player_bullets,
            enemy_bullets,
            { player },
            powerups,
            explosions,
            shockwaves, -- draw shockwaves on top of everything since they are supposed to affect the final game image
            function(game_object)
                game_object._draw()
            end
        )
        clip()

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
            shockwaves,
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