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

    local function as_6_digits_text_with_extra_zero()
        local text = current > 0 and tostr(current) or ""
        while #text < 5 do
            text = " " .. text
        end
        return text .. "0"
        -- DEBUG:
        --return " 98760"
    end

    local text_representation = as_6_digits_text_with_extra_zero()

    return {
        add = function(points)
            current = current + points
            text_representation = as_6_digits_text_with_extra_zero()
        end,

        raw_value = function()
            return current
        end,

        _draw = function(start_x, start_y, digit_color, blank_color, vertical)
            for i = 0, #text_representation - 1 do
                local x = start_x + (not vertical and i or 0) * 4
                local y = start_y + (vertical and i or 0) * 6
                print("8", x, y, blank_color)
                print(text_representation[i + 1], x, y, digit_color)
            end
        end,
    }
end
