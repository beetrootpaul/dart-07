-- -- -- -- -- -- -- -- --
-- poc/screen_poc.lua   --
-- -- -- -- -- -- -- -- --

function new_screen_poc()
    local level_number = __level_number
    local level = new_level(level_number)
    local player = new_player()

    local screen = {}

    function screen.update()
        if level.has_finished() then
            if level_number == 1 then
                if stat(102) == "www.lexaloffle.com" then
                    load("#tmp_multicart_lvl2")
                else
                    load("lvl2.p8")
                end
            end
            if level_number == 2 then
                if stat(102) == "www.lexaloffle.com" then
                    load("#tmp_multicart_lvl3")
                else
                    load("lvl3.p8")
                end
            end
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