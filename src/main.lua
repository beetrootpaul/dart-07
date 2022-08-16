-- -- -- -- --
-- main.lua --
-- -- -- -- --

local current_screen, next_screen

function _init()
    next_screen = new_screen_title()
end

function _update60()
    current_screen = next_screen
    next_screen = current_screen.update()
end

function _draw()
    cls(_color_dark_grey)
    current_screen.draw()
end
