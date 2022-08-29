-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/screen_mission_in_progress.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_in_progress()
    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)
    local player = new_player()
    local enemies = {}
    local player_bullets = {}
    local enemy_bullets = {}
    local powerups = {}
    local gui = new_gui()

    local armor = 3
    local is_triple_shot_enabled = false

    local throttled_fire_player_bullet = new_throttle(6, function()
        -- TODO: SFX
        add(player_bullets, new_player_bullet(player.x + 4, player.y))
        if is_triple_shot_enabled then
            -- TODO: different SFX
            add(player_bullets, new_player_bullet(player.x + 2, player.y - 5))
            add(player_bullets, new_player_bullet(player.x + 2, player.y + 5))
        end
    end)

    local function handle_player_damage()
        -- TODO: SFX
        armor = armor - 1
        if armor > 0 then
            player.start_invincibility_after_damage()
        else
            -- TODO: game over
            -- TODO: wait a moment after death
            _load_main_cart()
        end
    end

    local function increase_armor()
        armor = armor + 1
    end

    local function enable_triple_shot()
        is_triple_shot_enabled = true
    end

    --

    local screen = {}

    function screen.init()
    end

    function screen.update()
        local next = screen

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

        -- TODO: finish level on conditions different than a button press
        if btnp(_button_o) or level.has_reached_end() then
            -- TODO: externalize knowledge about amount of available missions
            if _mission_number < 3 then
                _load_level_cart(_mission_number + 1)
            else
                _load_main_cart()
            end
        end

        level.scroll()

        if btn(_button_left) then
            player.set_horizontal_movement("l")
        elseif btn(_button_right) then
            player.set_horizontal_movement("r")
        else
            player.set_horizontal_movement("-")
        end

        if btn(_button_up) then
            player.set_vertical_movement("u")
        elseif btn(_button_down) then
            player.set_vertical_movement("d")
        else
            player.set_vertical_movement("-")
        end

        -- TODO: make it decrease enemy's health
        if btn(_button_x) then
            throttled_fire_player_bullet.invoke()
        else
            -- TODO: ? reset interval ?
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

        for _, enemy in pairs(enemies) do
            enemy.advance_timers()
        end

        local player_cc = player.collision_circle()
        for _, powerup in pairs(powerups) do
            if _collisions.are_colliding(player_cc, powerup.collision_circle()) then
                -- TODO: SFX
                -- TODO: VFX on player
                -- TODO: VFX on armor status
                powerup.pick()
                if powerup.powerup_type == "a" then
                    increase_armor()
                elseif powerup.powerup_type == "t" then
                    enable_triple_shot()
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

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy {
                enemy_type = enemy_to_spawn.enemy_type,
                start_x = enemy_to_spawn.x,
                start_y = enemy_to_spawn.y,
                on_bullet_fired = function(enemy_bullet)
                    add(enemy_bullets, enemy_bullet)
                end,
                on_powerup_spawned = function(powerup)
                    add(powerups, powerup)
                end,
            })
        end

        player.animate()

        player.advance_timers()

        throttled_fire_player_bullet.advance_timer()

        return next
    end

    function screen.draw()
        clip(0, _gaoy, _gaw, _gah)
        do
            rectfill(0, _gaoy, _gaw - 1, _gaoy + _gah - 1, _bg_color)

            level.draw()

            for _, enemy_bullet in pairs(enemy_bullets) do
                enemy_bullet.draw()
            end

            for _, player_bullet in pairs(player_bullets) do
                player_bullet.draw()
            end

            for _, enemy in pairs(enemies) do
                enemy.draw()
            end

            for _, powerup in pairs(powerups) do
                powerup.draw()
            end

            player.draw()
        end
        clip()

        gui.draw(armor)

        -- DEBUG:
        --local player_cc = player.collision_circle()
        --oval(player_cc.x - (player_cc.r - .5), player_cc.y - (player_cc.r - .5), player_cc.x + (player_cc.r - .5), player_cc.y + (player_cc.r - .5), _color_11_dark_green)
        --for _, enemy in pairs(enemies) do
        --    local enemy_cc = enemy.collision_circle()
        --    oval(enemy_cc.x - (enemy_cc.r - .5), enemy_cc.y - (enemy_cc.r - .5), enemy_cc.x + (enemy_cc.r - .5), enemy_cc.y + (enemy_cc.r - .5), _color_11_dark_green)
        --end
        --for _, player_bullet in pairs(player_bullets) do
        --    local player_bullet_cc = player_bullet.collision_circle()
        --    oval(player_bullet_cc.x - (player_bullet_cc.r - .5), player_bullet_cc.y - (player_bullet_cc.r - .5), player_bullet_cc.x + (player_bullet_cc.r - .5), player_bullet_cc.y + (player_bullet_cc.r - .5), _color_11_dark_green)
        --end
        --for _, enemy_bullet in pairs(enemy_bullets) do
        --    local enemy_bullet_cc = enemy_bullet.collision_circle()
        --    oval(enemy_bullet_cc.x - (enemy_bullet_cc.r - .5), enemy_bullet_cc.y - (enemy_bullet_cc.r - .5), enemy_bullet_cc.x + (enemy_bullet_cc.r - .5), enemy_bullet_cc.y + (enemy_bullet_cc.r - .5), _color_11_dark_green)
        --end
        --for _, powerup in pairs(powerups) do
        --    local powerup_cc = powerup.collision_circle()
        --    oval(powerup_cc.x - (powerup_cc.r - .5), powerup_cc.y - (powerup_cc.r - .5), powerup_cc.x + (powerup_cc.r - .5), powerup_cc.y + (powerup_cc.r - .5), _color_11_dark_green)
        --end
    end

    return screen
end
