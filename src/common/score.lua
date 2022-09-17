-- -- -- -- -- -- -- --
-- common/score.lua  --
-- -- -- -- -- -- -- --

-- 0x40 is chosen here as divisor just because it was mentioned somewhere in the internet.
-- Maybe we can divide by more or maybe we lose precision even when dividing by 0x40,
-- who knows without doing proper math ¯\_(ツ)_/¯ 

-- Please pay attention to scores summed over all missions,
-- so they won't exceed max int of 32767 when summed up. 
function new_score(initial)
    local current = initial
    return {
        add = function(points)
            current = current + points
        end,
        raw_value = function()
            return current
        end,
        as_6_digits_text_with_extra_zero = function()
            local text = tostr(current) .. "0"
            while #text < 6 do
                text = "_" .. text
            end
            return text
        end,
    }
end
