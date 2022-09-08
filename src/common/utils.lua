-- -- -- -- -- -- -- --
-- common/utils.lua  --
-- -- -- -- -- -- -- --

function _angle_between(xy1, xy2)
    local dxy = xy2.minus(xy1)
    return atan2(dxy.x, dxy.y)
end

function _flattened_for_each(...)
    local args = { ... }
    local callback = args[#args]
    del(args, callback)

    for _, subarray in pairs(args) do
        for __, value in pairs(subarray) do
            callback(value, subarray)
        end
    end
end

function _noop()
    -- do nothing
end

function _outlined_print(text, x, y, text_color, outline_color)
    -- docs on control codes: https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Control_Codes
    for control_code in all(split "\-f,\-h,\|f,\|h,\+ff,\+hh,\+fh,\+hf") do
        print(control_code .. text, x, y, outline_color)
    end
    print(text, x, y, text_color)
end

function _round(value)
    return flr(value + .5)
end

-- next table index, where table is indexed from 1 and 
-- we want to go back to 1 after table length is reached 
function _tni(current_index, table_length)
    return current_index % table_length + 1
end