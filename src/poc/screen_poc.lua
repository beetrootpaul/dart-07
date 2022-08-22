-- -- -- -- -- -- -- -- --
-- poc/screen_poc.lua   --
-- -- -- -- -- -- -- -- --

function new_screen_poc()
    local level = new_level()
    
    local screen = {}

    function screen.update()
        return screen
    end

    function screen.draw()
        level.draw()
    end

    return screen
end