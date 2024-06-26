-- -- -- -- -- -- -- --
-- common/utils.lua  --
-- -- -- -- -- -- -- --

function _add_all(table, ...)
    for item in all { ... } do
        add(table, item)
    end
    return table
end

function _alternating_0_and_1()
    return flr(3 * t() % 2)
end

function _angle_between(xy1, xy2)
    local dxy = xy2.minus(xy1)
    return atan2(dxy.x, dxy.y)
end

function _centered_print(text, y, text_color, outline_color, forced_x)
    local w = print(text, 0, -5)
    local x = _gaox + (forced_x or _gawdb2) - w / 2

    if outline_color then
        -- docs on control codes: https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Control_Codes
        for control_code in all(split "\-f,\-h,\|f,\|h,\+ff,\+hh,\+fh,\+hf") do
            print(control_code .. text, x, y, outline_color)
        end
    end

    print(text, x, y, text_color)
end

function _flattened_for_each(...)
    local args = { ... }
    local callback = args[#args]
    del(args, callback)

    for subarray in all(args) do
        -- Iterate from N to 1 instead of using ALL(…), because in some callbacks we DEL(…) items.
        -- DEL(…) makes further table items shift one index down and ALL(…) is known for having issues
        -- with that when more than one DEL(…) happens within same ALL(…) iteration.
        -- Therefore, in general it would be better to iterate with an explicit control over the index
        -- and to do it from N to 1 in order to not have to care about higher items' position being affected.
        for i = #subarray, 1, -1 do
            callback(subarray[i], subarray)
        end
    end
end

function _noop()
    -- do nothing
end

_noop_game_object = {
    has_finished = function()
        return false
    end,
    _update = _noop,
    _draw = _noop,
}

-- next table index, where table is indexed from 1 and 
-- we want to go back to 1 after table length is reached 
function _tni(current_index, table_length)
    return current_index % table_length + 1
end

function _unpack_split(values_as_text, separator)
    -- passing nil separator down to split(…) will make it deafult to ","
    return unpack(split(values_as_text, separator))
end