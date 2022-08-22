-- -- -- -- --
-- main.lua --
-- -- -- -- --

local current_screen, next_screen

function _init()
    -- TODO: ???
    --next_screen = new_screen_title()
    next_screen = new_screen_poc()
end

function _update()
    current_screen = next_screen
    next_screen = current_screen.update()
end

function _draw()
    -- TODO: ???
    cls(_color_dark_blue)
    current_screen.draw()
end
