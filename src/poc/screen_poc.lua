-- -- -- -- -- -- -- -- --
-- poc/screen_poc.lua   --
-- -- -- -- -- -- -- -- --

function new_screen_poc()
    local level = new_level()
    local player = new_player()
    
    local screen = {}

    function screen.update()
        if level.has_finished() then
            level = new_level()
        end
        
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