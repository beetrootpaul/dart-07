-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/screen_mission_in_progress.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_in_progress()
    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)

    local player = new_player()

    local enemies = {}

    local screen = {}

    function screen.init()
    end

    function screen.update()
        local next = screen

        for _, enemy in pairs(enemies) do
            if enemy.has_finished() then
                -- TODO: is it OK to delete during iteration over pairs(…)?
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

        level.update()

        for _, enemy in pairs(enemies) do
            enemy.update()
        end

        player.update()

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            -- TODO: reconsider naming and what arugments to pass where
            add(enemies, new_enemy {
                enemy_type = enemy_to_spawn.enemy_type,
                center_x = enemy_to_spawn.center_x,
                center_y = enemy_to_spawn.center_y,
            })
        end

        return next
    end

    function screen.draw()
        cls(_bg_color)

        -- TODO: encapsulate GUI code, make it look good
        rectfill(0, 0, 127, 15, _color_0_black)
        rectfill(0, 112, 127, 127, _color_0_black)

        level.draw()

        player.draw()

        for _, enemy in pairs(enemies) do
            enemy.draw()
        end
    end

    return screen
end
