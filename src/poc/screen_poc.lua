-- -- -- -- -- -- -- -- --
-- poc/screen_poc.lua   --
-- -- -- -- -- -- -- -- --

function new_screen_poc()
    local level = new_level()
    local player = new_player()
    
    local screen = {}

    function screen.update()
        level.update()
        player.update()
        return screen
    end

    function screen.draw()
        level.draw()
        player.draw()
    end

    return screen
end