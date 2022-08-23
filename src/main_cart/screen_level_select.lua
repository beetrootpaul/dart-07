-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- main_cart/screen_level_select.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_level_select(score, number)
    local score = score
    local number = number

    local screen = {}

    local level = 1

    function screen.init()
        music(10)
    end

    function screen.update()
        local next = screen

        if btnp(_button_left) then
            number = number - 1
        end
        if btnp(_button_right) then
            number = number + 1
        end
        if btnp(_button_up) then
            level = level - 1
            if level < 1 then
                level = 3
            end
        end
        if btnp(_button_down) then
            level = level + 1
            if level > 3 then
                level = 1
            end
        end
        if btnp(_button_o) then
            sfx(10)
            score = score + 10
        end
        if btnp(_button_x) then

            -- user data addresses: 0x4300 .. 0x55ff
            local expected_max_addr = 0x4300 + 0x1000 + 0x44 * 5 + 0x44 * 5
            assert(expected_max_addr < 0x55ff, tostr(expected_max_addr, 0x1) .. " :-(")
            local dest_addr = 0x4300
            memcpy(dest_addr, 0x0, 0x1000) -- copy sprite sheet, sections 1 and 2
            dest_addr = dest_addr + 0x1000
            memcpy(dest_addr, 0x3200, 0x44 * 5) -- copy SFXs 0-5
            dest_addr = dest_addr + 0x44 * 5
            memcpy(dest_addr, 0x3200 + 0x44 * 20, 0x44 * 5) -- copy SFXs 20-25
            dest_addr = dest_addr + 0x44 * 5
            assert(expected_max_addr == dest_addr, "should be equal")

            local params = score .. "," .. number
            load("shmup-level-" .. level .. ".p8", nil, params)
            load("shmup/shmup-level-" .. level .. ".p8", nil, params)
            load("#tmp_multicart_lvl" .. level, nil, params)
        end

        return next
    end

    function screen.draw()
        cls(_color_lavender)
        print("score  : " .. score, 10, 10, _color_blue)
        print("number : " .. number, 10, 16, _color_blue)
        print("level 1", 30, 30, level == 1 and _color_red or _color_brown)
        print("level 2", 30, 50, level == 2 and _color_red or _color_brown)
        print("level 3", 30, 70, level == 3 and _color_red or _color_brown)
    end

    return screen
end
