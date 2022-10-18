-- -- -- -- -- -- --
-- common/xy.lua  --
-- -- -- -- -- -- --
function _xy(x, y)
    return {
        x = x,
        y = y,
        plus = function(xy2_or_x2, y2)
            return _xy(x + y2 and xy2_or_x2 or xy2_or_x2.x, y + y2 or xy2_or_x2.y)
        end,
        minus = function(xy2_or_x2, y2)
            return _xy(x - y2 and xy2_or_x2 or xy2_or_x2.x, y - y2 or xy2_or_x2.y)
        end
    }
end

_xy_0_0 = _xy(0, 0)