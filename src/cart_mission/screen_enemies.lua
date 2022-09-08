-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_enemies.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: consider combining screens into a single one, with a state management inside them

function new_screen_enemies(params)
    local level = params.level
    local player = params.player
    local player_bullets = params.player_bullets
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local is_fast_shot_enabled = params.is_fast_shot_enabled
    local hud = params.hud

    local enemies = {}
    local enemy_bullets = {}
    local powerups = {}
    local explosions = {}

    -- TODO: duplicated code
    local function handle_player_damage()
        -- TODO: powerups retrieval after live lost?
        -- TODO: SFX
        is_triple_shot_enabled = false
        is_fast_shot_enabled = false
        -- TODO: VFX of disappearing health segment
        health = health - 1
        player.take_damage(health)
    end

    -- TODO: a little bit of duplicated code
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
                        health = health + 1
                    elseif powerup.powerup_type == "t" then
                        is_triple_shot_enabled = true
                    elseif powerup.powerup_type == "f" then
                        is_fast_shot_enabled = true
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

    local screen = {}

    function screen._init()
        level.enter_phase_main()

        player.set_on_destroyed(function(collision_circle)
            -- TODO: explosion SFX
            -- TODO: duplication
            add(explosions, new_explosion(collision_circle.xy, 1 * collision_circle.r))
            add(explosions, new_explosion(collision_circle.xy, 2 * collision_circle.r, 4 + flr(rnd(8))))
            add(explosions, new_explosion(collision_circle.xy, 3 * collision_circle.r, 12 + flr(rnd(8))))
        end)
    end

    function screen._update()
        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        if btn(_button_x) then
            player.fire {
                is_triple_shot_enabled = is_triple_shot_enabled,
                is_fast_shot_enabled = is_fast_shot_enabled,
            }
        end

        _flattened_for_each(
            { level },
            { player },
            enemies,
            player_bullets,
            enemy_bullets,
            powerups,
            explosions,
            { hud },
            function(game_object)
                game_object._update()
            end
        )

        handle_collisions()

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy {
                enemy_properties = _m.enemy_properties_for(enemy_to_spawn.enemy_map_marker),
                start_xy = enemy_to_spawn.xy,
                on_bullets_spawned = function(spawned_enemy_bullets_fn, enemy_movement)
                    for _, seb in pairs(spawned_enemy_bullets_fn(enemy_movement, player.collision_circle())) do
                        add(enemy_bullets, seb)
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
    end

    function screen._draw()
        cls(_m.bg_color)
        clip(_gaox, 0, _gaw, _gah)
        _flattened_for_each(
            { level },
            enemy_bullets,
            player_bullets,
            enemies,
            powerups,
            { player },
            explosions,
            function(game_object)
                game_object._draw()
            end
        )
        clip()

        hud._draw {
            player_health = health,
        }

        -- DEBUG:
        --_flattened_for_each(
        --    { player },
        --    enemies,
        --    player_bullets,
        --    enemy_bullets,
        --    powerups,
        --    function(game_object)
        --        _collisions._debug_draw_collision_circle(game_object.collision_circle())
        --    end
        --)
    end

    function screen._post_draw()
        _flattened_for_each(
            enemies,
            powerups,
            player_bullets,
            enemy_bullets,
            explosions,
            function(game_object, game_objects)
                if game_object.has_finished() then
                    del(game_objects, game_object)
                end
            end
        )

        if level.has_scrolled_to_end() and #enemies <= 0 and #enemy_bullets <= 0 and #powerups <= 0 then
            return new_screen_boss_intro {
                level = level,
                player = player,
                player_bullets = player_bullets,
                explosions = explosions,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                is_fast_shot_enabled = is_fast_shot_enabled,
                hud = hud,
            }
        end

        if health <= 0 then
            -- TODO: should we keep remaining player bullets visible? Should we allow them to hit boss after intro (even if practically impossible)? If not, should we nicely destroy them?
            return new_screen_defeat {
                level = level,
                enemies = enemies,
                boss = nil,
                enemy_bullets = enemy_bullets,
                boss_bullets = {},
                explosions = explosions,
                health = health,
                hud = hud,
            }
        end
    end

    return screen
end
