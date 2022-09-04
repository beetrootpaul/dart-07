-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_enemies.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_enemies(params)
    local level = params.level
    local player = params.player
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local enemies = {}
    local player_bullets = {}
    local enemy_bullets = {}
    local powerups = {}
    local explosions = {}

    -- TODO: duplicated code
    local function handle_player_damage()
        -- TODO NEXT: powerups retrieval after live lost?
        -- TODO: SFX
        is_triple_shot_enabled = false
        -- TODO NEXT: player defeat explosion
        -- TODO: VFX of disappearing health segment
        health = health - 1
        if health > 0 then
            player.start_invincibility_after_damage()
        end
    end

    local function enable_triple_shot()
        is_triple_shot_enabled = true
    end

    -- TODO: a little bit of duplicated code
    local function handle_collisions()
        local player_cc = player.collision_circle()

        -- player vs powerups
        for _, powerup in pairs(powerups) do
            -- TODO: magnet?
            if _collisions.are_colliding(player_cc, powerup.collision_circle()) then
                -- TODO: SFX
                -- TODO: VFX on player
                -- TODO: VFX on health status
                powerup.pick()
                if powerup.powerup_type == "a" then
                    health = health + 1
                elseif powerup.powerup_type == "t" then
                    enable_triple_shot()
                end
            end
        end

        -- player bullets vs enemies + player vs enemies
        for _, enemy in pairs(enemies) do
            local enemy_cc = enemy.collision_circle()
            for __, player_bullet in pairs(player_bullets) do
                if not enemy.has_finished() then
                    if _collisions.are_colliding(player_bullet.collision_circle(), enemy_cc) then
                        -- TODO: SFX
                        enemy.take_damage()
                        player_bullet.destroy()
                        -- TODO: magnetised score items?
                    end
                end
            end
            if not enemy.has_finished() and not player.is_invincible_after_damage() then
                if _collisions.are_colliding(player_cc, enemy_cc) then
                    handle_player_damage()
                end
            end
        end

        -- player vs enemy bullets
        for _, enemy_bullet in pairs(enemy_bullets) do
            if not player.is_invincible_after_damage() then
                if _collisions.are_colliding(enemy_bullet.collision_circle(), player_cc) then
                    handle_player_damage()
                end
            end
        end
    end

    --

    local screen = {}

    -- TODO: consider enabling extra layer of music
    function screen._init()
        level.enter_phase_main()
        player.set_on_bullets_spawned(function(bullets)
            for _, b in pairs(bullets) do
                add(player_bullets, b)
            end
        end)
    end

    function screen._update()
        -- TODO: REMOVE THIS
        if btnp(_button_o) then
            if _m.mission_number < _max_mission_number then
                _load_mission_cart {
                    mission_number = _m.mission_number,
                    health = _health_default,
                    is_triple_shot_enabled = false
                }
            else
                _load_main_cart()
            end
        end

        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        if btn(_button_x) then
            player.fire {
                is_triple_shot_enabled = is_triple_shot_enabled,
            }
        end

        level._update()
        player._update()

        _go_update(enemies)
        _go_update(player_bullets)
        _go_update(enemy_bullets)
        _go_update(powerups)
        _go_update(explosions)

        hud._update()

        handle_collisions()

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy {
                enemy_properties = _m.enemy_properties_for(enemy_to_spawn.enemy_map_marker),
                start_xy = enemy_to_spawn.xy,
                on_bullets_spawned = function(spawned_enemy_bullets)
                    for _, seb in pairs(spawned_enemy_bullets) do
                        add(enemy_bullets, seb)
                    end
                end,
                on_destroyed = function(collision_circle, powerup_type)
                    -- TODO: explosion SFX
                    add(explosions, new_explosion(collision_circle.xy, 2 * collision_circle.r))
                    if powerup_type ~= "-" then
                        -- TODO: implement more powerup types: circling orb? diagonal shot? laser? power field?
                        -- TODO: indicate powerups in hud
                        add(powerups, new_powerup(collision_circle.xy, powerup_type))
                    end
                end,
            })
        end
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                _go_draw(enemy_bullets)
                _go_draw(player_bullets)
                _go_draw(enemies)
                _go_draw(powerups)
                player._draw()
                _go_draw(explosions)
            end,
        }
        hud._draw {
            player_health = health,
        }

        -- DEBUG:
        --_collisions._debug_draw_collision_circle(player.collision_circle())
        --_go_draw_debug_collision_circles(enemies)
        --_go_draw_debug_collision_circles(player_bullets)
        --_go_draw_debug_collision_circles(enemy_bullets)
        --_go_draw_debug_collision_circles(powerups)
    end

    function screen._post_draw()
        _go_delete_finished(enemies)
        _go_delete_finished(powerups)
        _go_delete_finished(player_bullets)
        _go_delete_finished(enemy_bullets)
        _go_delete_finished(explosions)

        if level.has_scrolled_to_end() and #enemies <= 0 and #enemy_bullets <= 0 and #powerups <= 0 then
            return new_screen_boss_intro {
                level = level,
                player = player,
                player_bullets = player_bullets,
                explosions = explosions,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                hud = hud,
            }
        end

        if health <= 0 then
            -- TODO NEXT: game over screen
            -- TODO NEXT: wait a moment after death
            _load_main_cart()
        end
    end

    return screen
end
