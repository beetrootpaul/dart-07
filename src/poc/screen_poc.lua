-- -- -- -- -- -- -- -- --
-- poc/screen_poc.lua   --
-- -- -- -- -- -- -- -- --

function new_screen_poc()
    local level_number = 1
    local level = new_level(level_number)
    local player = new_player()
    
    local screen = {}

    function screen.update()
        if level.has_finished() then
            level_number = level_number + 1
            if level_number == 2 then
                reload(0x1000, 0x1000, 0x1000, "lvl2.p8")
            end
            if level_number == 3 then
                reload(0x1000, 0x1000, 0x1000, "lvl3.p8")
            end
            level = new_level(level_number)
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