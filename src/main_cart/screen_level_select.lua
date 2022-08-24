-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- main_cart/screen_level_select.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: rename this file to screen_mission_choice.lua

-- TODO: create a decent mission choice screen

-- TODO: ?
--function new_screen_level_select(score, number)
function new_screen_level_select()
    -- TODO: ?
    --local score = score
    --local number = number

    local chosen_level = 1

    local screen = {}

    function screen.init()
        -- TODO: ?
        --music(10)
    end

    function screen.update()
        local next = screen

        -- TODO: ?
        --if btnp(_button_left) then
        --    number = number - 1
        --end
        --if btnp(_button_right) then
        --    number = number + 1
        --end

        if btnp(_button_up) then
            chosen_level = chosen_level - 1
        end
        if btnp(_button_down) then
            chosen_level = chosen_level + 1
        end
        -- TODO: externalize knowledge about amount of available missions
        chosen_level = (chosen_level - 1) % 3 + 1

        -- TODO: ?
        --if btnp(_button_o) then
        --sfx(10)
        --score = score + 10
        --end

        -- TODO: make it clear for the user which button is to be pressed
        if btnp(_button_x) then
            _copy_shared_assets_from_transferable_ram()
            _load_level_cart(chosen_level)
        end

        return next
    end

    function screen.draw()
        cls(_color_0_black)

        -- TODO: ?
        --print("score  : " .. score, 10, 10, _color_12_true_blue)
        --print("number : " .. number, 10, 16, _color_12_true_blue)

        -- TODO: decent mission selection
        -- TODO: externalize knowledge about amount of available levels
        print("mission 1", 30, 30, chosen_level == 1 and _color_15_light_peach or _color_13_mauve)
        print("mission 2", 30, 50, chosen_level == 2 and _color_15_light_peach or _color_13_mauve)
        print("mission 3", 30, 70, chosen_level == 3 and _color_15_light_peach or _color_13_mauve)
        -- TODO: add mission 4
    end

    return screen
end
