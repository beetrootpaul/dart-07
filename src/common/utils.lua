-- -- -- -- -- -- -- --
-- common/utils.lua  --
-- -- -- -- -- -- -- --

function _noop()
    -- do nothing
end

-- next table index, where table is indexed from 1 and 
-- we want to go back to 1 after table length is reached 
function _tni(current_index, table_length)
    return current_index % table_length + 1
end