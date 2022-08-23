-- -- -- -- -- -- -- -- -- -- --
-- main_cart/screen_title.lua --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_title(score, number)
    local score = score
    local number = number

    local screen = {}

    function screen.init()
        --music(0)
    end

    function screen.update()
        local next = screen

        if btnp(_button_left) then
            number = number - 1
        end
        if btnp(_button_right) then
            number = number + 1
        end
        if btnp(_button_o) then
            --sfx(0)
            score = score + 10
        end
        if btnp(_button_x) then
            next = new_screen_level_select(score, number)
        end

        return next
    end

    function screen.draw()
        cls(_color_0_black)
        print("score  : " .. score, 10, 10, _color_12_true_blue)
        print("number : " .. number, 10, 16, _color_12_true_blue)
        print("title screen", 40, 40, _color_12_true_blue)
    end

    return screen
end
