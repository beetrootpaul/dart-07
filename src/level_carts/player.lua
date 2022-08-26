-- -- -- -- -- -- -- -- -- --
-- level_carts/player.lua  --
-- -- -- -- -- -- -- -- -- --

function new_player()
    -- TODO: calculate proper centered position
    local x = 20
    local y = 60
    local speed = 2

    return {
        update = function()
            -- TODO: rework movement, externalize speed
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
            -- TODO: externalize sprite number
            spr(1, x, y)
        end,
    }
end