-- -- -- -- -- -- --
-- poc/player.lua --
-- -- -- -- -- -- --

function new_player()
    local x = 20
    local y = 60

    return {
        update = function()
            if btn(_button_left) then
                x = x - 2
            end
            if btn(_button_right) then
                x = x + 2
            end
            if btn(_button_up) then
                y = y - 2
            end
            if btn(_button_down) then
                y = y + 2
            end
        end,
        draw = function()
            spr(1, x, y)
        end,
    }
end