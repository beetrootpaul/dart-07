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

        level.update()

        for _, enemy in pairs(enemies) do
            enemy.update()
        end

        player.update()

        local enemies_to_spawn = level.enemies_to_spawn()
        for _, enemy_to_spawn in pairs(enemies_to_spawn) do
            add(enemies, new_enemy(enemy_to_spawn.enemy_type, enemy_to_spawn.x, enemy_to_spawn.y))
        end

        return next
    end

    function screen.draw()
        clip(0, _gaoy, _gaw, _gah)
        rectfill(0, _gaoy, _gaw - 1, _gaoy + _gah - 1, _bg_color)
        level.draw()
        player.draw()
        for _, enemy in pairs(enemies) do
            enemy.draw()
        end
        clip()

        -- TODO: encapsulate GUI code, make it look good
        rectfill(0, 0, 127, 15, _color_0_black)
        rectfill(0, 112, 127, 127, _color_0_black)
    end

    return screen
end
