-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/screen_mission_in_progress.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_in_progress()
    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)

    local player = new_player()

    local enemies = {}

    -- TODO: deduct armor on collision
    local armor = 3

    local gui = new_gui()

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

        -- TODO: finish level on conditions different than a button press
        if btnp(_button_x) or level.has_reached_end() then
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

        for _, enemy in pairs(enemies) do
            enemy.move()
        end

        local player_cc = player.collision_circle()
        for _, enemy in pairs(enemies) do
            if not player.is_invincible_after_damage() then
                if _collisions.are_colliding(player_cc, enemy.collision_circle()) then
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
            end
        end

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy(enemy_to_spawn.enemy_type, enemy_to_spawn.x, enemy_to_spawn.y))
        end

        player.animate()

        player.advance_timers()

        return next
    end

    function screen.draw()
        clip(0, _gaoy, _gaw, _gah)
        rectfill(0, _gaoy, _gaw - 1, _gaoy + _gah - 1, _bg_color)
        level.draw()
        for _, enemy in pairs(enemies) do
            enemy.draw()
        end
        player.draw()
        clip()

        gui.draw(armor)

        -- DEBUG:
        --local player_cc = player.collision_circle()
        --oval(player_cc.x - (player_cc.r - .5), player_cc.y - (player_cc.r - .5), player_cc.x + (player_cc.r - .5), player_cc.y + (player_cc.r - .5), _color_11_dark_green)
        --for _, enemy in pairs(enemies) do
        --    local enemy_cc = enemy.collision_circle()
        --    oval(enemy_cc.x - (enemy_cc.r - .5), enemy_cc.y - (enemy_cc.r - .5), enemy_cc.x + (enemy_cc.r - .5), enemy_cc.y + (enemy_cc.r - .5), _color_11_dark_green)
        --end
    end

    return screen
end
