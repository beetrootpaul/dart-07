-- -- -- -- -- -- -- -- -- --
-- main_cart/main_cart.lua --
-- -- -- -- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local score = tonum(split(stat(6))[1]) or 2
    local number = tonum(split(stat(6))[2]) or -3
    next_screen = new_screen_title(score, number)
end

function _update()
    if current_screen ~= next_screen then
        next_screen.init()
    end
    current_screen = next_screen
    next_screen = current_screen.update()
end

function _draw()
    current_screen.draw()
end
