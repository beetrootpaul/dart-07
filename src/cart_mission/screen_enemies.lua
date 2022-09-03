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

    -- TODO: duplicated code
    local throttled_fire_player_bullet = new_throttle(6, function()
        -- TODO: SFX
        add(player_bullets, new_player_bullet { start_xy = player.xy.plus(0, -4) })
        if is_triple_shot_enabled then
            -- TODO: different SFX
            add(player_bullets, new_player_bullet { start_xy = player.xy.plus(-5, -2) })
            add(player_bullets, new_player_bullet { start_xy = player.xy.plus(5, -2) })
        end
    end)

    -- TODO: duplicated code
    local function handle_player_damage()
        -- TODO: powerups retrieval after live lost?
        -- TODO: SFX
        is_triple_shot_enabled = false
        -- TODO: VFX of disappearing health segment
        health = health - 1
        if health > 0 then
            player.start_invincibility_after_damage()
        end
    end

    local function increase_health()
        health = health + 1
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
                    increase_health()
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
                        -- TODO: blinking enemy if still alive
                        -- TODO: explosion if no longer alive
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

        -- TODO: duplicated code
        if btn(_button_down) then
            player.set_vertical_movement("d")
        elseif btn(_button_up) then
            player.set_vertical_movement("u")
        else
            player.set_vertical_movement("-")
        end
        if btn(_button_left) then
            player.set_horizontal_movement("l")
        elseif btn(_button_right) then
            player.set_horizontal_movement("r")
        else
            player.set_horizontal_movement("-")
        end

        if btn(_button_x) then
            throttled_fire_player_bullet.invoke()
        end

        level._update()
        player._update()
        for _, enemy in pairs(enemies) do
            enemy._update()
        end
        for _, player_bullet in pairs(player_bullets) do
            player_bullet._update()
        end
        for _, enemy_bullet in pairs(enemy_bullets) do
            enemy_bullet._update()
        end
        for _, powerup in pairs(powerups) do
            powerup._update()
        end
        throttled_fire_player_bullet._update()
        hud._update()

        handle_collisions()

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy {
                enemy_properties = _m.enemy_properties_for(enemy_to_spawn.enemy_map_marker, enemy_to_spawn.xy),
                start_xy = enemy_to_spawn.xy,
                on_bullets_spawned = function(spawned_enemy_bullets)
                    for _, seb in pairs(spawned_enemy_bullets) do
                        add(enemy_bullets, seb)
                    end
                end,
                on_powerup_spawned = function(powerup)
                    -- TODO: implement more powerup types
                    -- TODO: indicate powerups in hud
                    add(powerups, powerup)
                end,
            })
        end
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                for _, enemy_bullet in pairs(enemy_bullets) do
                    enemy_bullet._draw()
                end
                for _, player_bullet in pairs(player_bullets) do
                    player_bullet._draw()
                end
                for _, enemy in pairs(enemies) do
                    enemy._draw()
                end
                for _, powerup in pairs(powerups) do
                    powerup._draw()
                end
                player._draw()
            end,
        }
        hud._draw {
            player_health = health,
        }

        -- DEBUG:
        _collisions._debug_draw_collision_circle(player.collision_circle())
        for _, enemy in pairs(enemies) do
            _collisions._debug_draw_collision_circle(enemy.collision_circle())
        end
        for _, player_bullet in pairs(player_bullets) do
            _collisions._debug_draw_collision_circle(player_bullet.collision_circle())
        end
        for _, enemy_bullet in pairs(enemy_bullets) do
            _collisions._debug_draw_collision_circle(enemy_bullet.collision_circle())
        end
        for _, powerup in pairs(powerups) do
            _collisions._debug_draw_collision_circle(powerup.collision_circle())
        end
    end

    function screen._post_draw()
        for index, enemy in pairs(enemies) do
            if enemy.has_finished() then
                del(enemies, enemy)
            end
        end
        for index, powerup in pairs(powerups) do
            if powerup.has_finished() then
                del(powerups, powerup)
            end
        end
        for index, player_bullet in pairs(player_bullets) do
            if player_bullet.has_finished() then
                del(player_bullets, player_bullet)
            end
        end
        for index, enemy_bullet in pairs(enemy_bullets) do
            if enemy_bullet.has_finished() then
                del(enemy_bullets, enemy_bullet)
            end
        end

        if level.has_scrolled_to_end() and #enemies <= 0 and #enemy_bullets <= 0 and #powerups <= 0 then
            return new_screen_boss_intro {
                level = level,
                player = player,
                player_bullets = player_bullets,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                hud = hud,
            }
        end

        if health <= 0 then
            -- TODO: game over
            -- TODO: wait a moment after death
            _load_main_cart()
        end
    end

    return screen
end
