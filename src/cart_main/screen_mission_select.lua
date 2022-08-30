-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_mission_select.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: create a decent mission selection screen

function new_screen_mission_select()
    local selected_mission = 1

    --

    local screen = {}

    function screen.init()
        -- TODO: ?
        --music(10)
    end

    function screen.update()
        local next = screen

        if btnp(_button_up) then
            selected_mission = selected_mission - 1
        end
        if btnp(_button_down) then
            selected_mission = selected_mission + 1
        end
        selected_mission = (selected_mission - 1) % _max_mission_number + 1

        -- TODO: make it clear for the user which button is to be pressed
        if btnp(_button_x) then
            _copy_shared_assets_from_transferable_ram()
            _load_mission_cart(selected_mission)
        end

        return next
    end

    function screen.draw()
        cls(_color_0_black)

        -- TODO: decent mission selection
        print("mission 1", 30, 30, selected_mission == 1 and _color_6_light_grey or _color_13_mauve)
        print("mission 2", 30, 50, selected_mission == 2 and _color_6_light_grey or _color_13_mauve)
        print("mission 3", 30, 70, selected_mission == 3 and _color_6_light_grey or _color_13_mauve)
    end

    return screen
end
