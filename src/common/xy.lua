-- -- -- -- -- -- -- -- --
-- common/vectors.lua   --
-- -- -- -- -- -- -- -- --

function _xy(x, y)
    return {
        x = x,
        y = y,
        plus = function(xy2_or_x2, y2)
            if type(xy2_or_x2) == "number" then
                return _xy(x + xy2_or_x2, y + y2)
            end
            return _xy(x + xy2_or_x2.x, y + xy2_or_x2.y)
        end,
        minus = function(xy2_or_x2, y2)
            if type(xy2_or_x2) == "number" then
                return _xy(x - xy2_or_x2, y - y2)
            end
            return _xy(x - xy2_or_x2.x, y - xy2_or_x2.y)
        end,
        flr = function()
            return _xy(flr(x), flr(y))
        end,
        ceil = function()
            return _xy(ceil(x), ceil(y))
        end,
        set_x = function(x2)
            return _xy(x2, y)
        end,
        set_y = function(y2)
            return _xy(x, y2)
        end,
    }
end
