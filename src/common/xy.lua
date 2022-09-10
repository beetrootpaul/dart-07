-- -- -- -- -- -- --
-- common/xy.lua  --
-- -- -- -- -- -- --

function _xy(x, y)
    return {
        x = x,
        y = y,
        plus = function(xy2_or_x2, y2)
            return type(xy2_or_x2) == "number" and
                _xy(x + xy2_or_x2, y + y2) or
                _xy(x + xy2_or_x2.x, y + xy2_or_x2.y)
        end,
        minus = function(xy2_or_x2, y2)
            return type(xy2_or_x2) == "number" and
                _xy(x - xy2_or_x2, y - y2) or
                _xy(x - xy2_or_x2.x, y - xy2_or_x2.y)
        end,
        flr = function()
            return _xy(flr(x), flr(y))
        end,
        ceil = function()
            return _xy(ceil(x), ceil(y))
        end,
        round = function()
            return _xy(_round(x), _round(y))
        end,
    }
end
