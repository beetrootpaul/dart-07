-- -- -- -- -- -- -- --
-- common/utils.lua  --
-- -- -- -- -- -- -- --

function _add_all(table, ...)
    for item in all({ ... }) do
        add(table, item)
    end
    return table
end

function _angle_between(xy1, xy2)
    local dxy = xy2.minus(xy1)
    return atan2(dxy.x, dxy.y)
end

function _flattened_for_each(...)
    local args = { ... }
    local callback = args[#args]
    del(args, callback)

    for subarray in all(args) do
        for value in all(subarray) do
            callback(value, subarray)
        end
    end
end

function _noop()
    -- do nothing
end

function _outlined_centered_print(text, y, text_color, outline_color)
    local w = print(text, 0, -5)
    local x = _gaox + (_gaw - w) / 2
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