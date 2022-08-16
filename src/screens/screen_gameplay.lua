-- -- -- -- -- -- -- -- -- -- --
-- screens/screen_gameplay.lua   --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_gameplay()
    local gameplay = new_gameplay()

    local screen = {}

    function screen.update()
        gameplay.update()
        return screen
    end

    function screen.draw()
        gameplay.draw()
        print "gameplay"
    end

    return screen
end