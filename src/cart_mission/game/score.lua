-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/score.lua   --
-- -- -- -- -- -- -- -- -- -- -- --

-- 0x40 is chosen here as divisor just because it was mentioned somewhere in the internet.
-- Maybe we can divide by more or maybe we lose precision even when dividing by 0x40,
-- who knows without doing proper math ¯\_(ツ)_/¯ 

function new_score(initial)
    local current = initial / 0x40
    return {
        value = function()
            return _round(current * 0x40)
        end,
        add = function(points)
            current = current + points / 0x40
        end,
    }
end
