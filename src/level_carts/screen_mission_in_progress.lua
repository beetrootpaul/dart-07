-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/screen_mission_in_progress.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_in_progress()
    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)

    local player = new_player()

    local screen = {}

    function screen.init()
    end

    function screen.update()
        local next = screen

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

        player.update()

        return next
    end

    function screen.draw()
        cls(_bg_color)

        -- TODO: encapsulate GUI code, make it look good
        rectfill(0, 0, 127, 15, _color_0_black)
        rectfill(0, 112, 127, 127, _color_0_black)

        level.draw()

        player.draw()
    end

    return screen
end
