-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_mission.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission(params)
    local level = params.level
    local player = params.player
    local health = params.health
    local hud = params.hud

    local enemies = {}
    local player_bullets = {}
    local enemy_bullets = {}
    local powerups = {}
    local boss

    local is_triple_shot_enabled = false

    local throttled_fire_player_bullet = new_throttle(6, function()
        -- TODO: SFX
        add(player_bullets, new_player_bullet { start_x = player.x, start_y = player.y - 4 })
        if is_triple_shot_enabled then
            -- TODO: different SFX
            add(player_bullets, new_player_bullet { start_x = player.x - 5, start_y = player.y - 2 })
            add(player_bullets, new_player_bullet { start_x = player.x + 5, start_y = player.y - 2 })
        end
    end)

    local function handle_player_damage()
        -- TODO: powerups retrieval after live lost?
        -- TODO: SFX
        is_triple_shot_enabled = false
        -- TODO: VFX of disappearing health segment
        health = health - 1
        if health > 0 then
            player.start_invincibility_after_damage()
        else
            -- TODO: game over
            -- TODO: wait a moment after death
            _load_main_cart()
        end
    end

    local function increase_health()
        health = health + 1
    end

    local function enable_triple_shot()
        is_triple_shot_enabled = true
    end

    local function load_next_cart()
        if _m.mission_number < _max_mission_number then
            _load_mission_cart {
                mission_number = _m.mission_number + 1,
                health = health,
            }
        else
            _load_main_cart()
        end
    end

    --

    local screen = {}

    function screen.init()
        level.enter_phase_main()
    end

    function screen.update()
        local next_screen = screen

        if boss and boss.has_finished() then
            -- TODO: nice post-boss-destroy visuals before transitioning to the next cart
            -- TODO: fade screen out
            -- TODO: fade next screen in
            load_next_cart()
        end
        
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

        if not boss and level.has_scrolled_to_end() and #enemies <= 0 and #enemy_bullets <= 0 then
            -- TODO: boss slide in
            -- TODO: boss health bar
            -- TODO: boss spectacular destroy VFX and SFX
            -- TODO: win screen after all 3 levels
            boss = new_boss {
                boss_properties = _m.boss_properties(),
                on_bullets_spawned = function(spawned_enemy_bullets)
                    for _, seb in pairs(spawned_enemy_bullets) do
                        add(enemy_bullets, seb)
                    end
                end,
            }
        end

        -- TODO: remove this ability to skip a mission with a button press
        if btnp(_button_o) then
            load_next_cart()
        end

        level.scroll()

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

        if boss then
            boss.move()
        end
        for _, enemy in pairs(enemies) do
            enemy.move()
        end

        for _, powerup in pairs(powerups) do
            powerup.move()
        end
        for _, player_bullet in pairs(player_bullets) do
            player_bullet.move()
        end
        for _, enemy_bullet in pairs(enemy_bullets) do
            enemy_bullet.move()
        end

        if boss then
            boss.advance_timers()
        end
        for _, enemy in pairs(enemies) do
            enemy.advance_timers()
        end

        do
            local player_cc = player.collision_circle()

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

            if boss then
                local boss_cc = boss.collision_circle()
                for __, player_bullet in pairs(player_bullets) do
                    if not boss.has_finished() then
                        if _collisions.are_colliding(player_bullet.collision_circle(), boss_cc) then
                            -- TODO: SFX
                            -- TODO: blinking boss if still alive
                            -- TODO: big explosion if no longer alive
                            boss.take_damage()
                            player_bullet.destroy()
                            -- TODO: magnetised score items?
                        end
                    end
                end
                if not boss.has_finished() and not player.is_invincible_after_damage() then
                    if _collisions.are_colliding(player_cc, boss_cc) then
                        handle_player_damage()
                    end
                end
            end

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

            for _, enemy_bullet in pairs(enemy_bullets) do
                if not player.is_invincible_after_damage() then
                    if _collisions.are_colliding(enemy_bullet.collision_circle(), player_cc) then
                        handle_player_damage()
                    end
                end
            end
        end

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy {
                enemy_properties = _m.enemy_properties_for(enemy_to_spawn.enemy_map_marker, enemy_to_spawn.x, enemy_to_spawn.y),
                on_bullets_spawned = function(spawned_enemy_bullets)
                    for _, seb in pairs(spawned_enemy_bullets) do
                        add(enemy_bullets, seb)
                    end
                end,
                on_powerup_spawned = function(powerup)
                    add(powerups, powerup)
                end,
            })
        end

        player.animate()

        player.advance_timers()

        throttled_fire_player_bullet.advance_timer()

        hud.animate()

        return next_screen
    end

    function screen.draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level.draw {
            draw_within_level_bounds = function()
                for _, enemy_bullet in pairs(enemy_bullets) do
                    enemy_bullet.draw()
                end
                for _, player_bullet in pairs(player_bullets) do
                    player_bullet.draw()
                end
                if boss then
                    boss.draw()
                end
                for _, enemy in pairs(enemies) do
                    enemy.draw()
                end
                for _, powerup in pairs(powerups) do
                    powerup.draw()
                end
                player.draw()
            end,
        }

        hud.draw(health)

        -- DEBUG:
        local player_cc = player.collision_circle()
        oval(player_cc.x - (player_cc.r - .5), player_cc.y - (player_cc.r - .5), player_cc.x + (player_cc.r - .5), player_cc.y + (player_cc.r - .5), _color_11_dark_green)
        if boss then
            local boss_cc = boss.collision_circle()
            oval(boss_cc.x - (boss_cc.r - .5), boss_cc.y - (boss_cc.r - .5), boss_cc.x + (boss_cc.r - .5), boss_cc.y + (boss_cc.r - .5), _color_11_dark_green)
        end
        for _, enemy in pairs(enemies) do
            local enemy_cc = enemy.collision_circle()
            oval(enemy_cc.x - (enemy_cc.r - .5), enemy_cc.y - (enemy_cc.r - .5), enemy_cc.x + (enemy_cc.r - .5), enemy_cc.y + (enemy_cc.r - .5), _color_11_dark_green)
        end
        for _, player_bullet in pairs(player_bullets) do
            local player_bullet_cc = player_bullet.collision_circle()
            oval(player_bullet_cc.x - (player_bullet_cc.r - .5), player_bullet_cc.y - (player_bullet_cc.r - .5), player_bullet_cc.x + (player_bullet_cc.r - .5), player_bullet_cc.y + (player_bullet_cc.r - .5), _color_11_dark_green)
        end
        for _, enemy_bullet in pairs(enemy_bullets) do
            local enemy_bullet_cc = enemy_bullet.collision_circle()
            oval(enemy_bullet_cc.x - (enemy_bullet_cc.r - .5), enemy_bullet_cc.y - (enemy_bullet_cc.r - .5), enemy_bullet_cc.x + (enemy_bullet_cc.r - .5), enemy_bullet_cc.y + (enemy_bullet_cc.r - .5), _color_11_dark_green)
        end
        for _, powerup in pairs(powerups) do
            local powerup_cc = powerup.collision_circle()
            oval(powerup_cc.x - (powerup_cc.r - .5), powerup_cc.y - (powerup_cc.r - .5), powerup_cc.x + (powerup_cc.r - .5), powerup_cc.y + (powerup_cc.r - .5), _color_11_dark_green)
        end
    end

    return screen
end
