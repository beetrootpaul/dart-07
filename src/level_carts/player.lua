-- -- -- -- -- -- -- -- -- --
-- level_carts/player.lua  --
-- -- -- -- -- -- -- -- -- --

function new_player()
    local w = 10
    local h = 10
    local x = 12
    local y = _gaoy + flr((_gah - h) / 2)
    local speed = 2

    return {
        update = function()
            if btn(_button_left) then
                x = x - speed
            end
            if btn(_button_right) then
                x = x + speed
            end
            if btn(_button_up) then
                y = y - speed
            end
            if btn(_button_down) then
                y = y + speed
            end
        end,

        draw = function()
            -- TODO: make it animated
            palt(_color_0_black, false)
            palt(_color_11_dark_green, true)
            sspr(8, 10, w, h, x, y)
            palt()
            sspr(4, 8, 4, 4, x - 5, y + 3)
        end,
    }
end