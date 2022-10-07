-- -- -- -- -- -- -- --
-- common/vec2d.lua  --
-- -- -- -- -- -- -- --

do
    local prototype = {
        -- TODO: REMOVE
        plus = function(self, xy2_or_x2, y2)
            return _xy(
                self.x + (y2 and xy2_or_x2 or xy2_or_x2.x),
                self.y + (y2 or xy2_or_x2.y)
            )
        end,
        -- TODO: REMOVE
        minus = function(self, xy2_or_x2, y2)
            return _xy(
                self.x - (y2 and xy2_or_x2 or xy2_or_x2.x),
                self.y - (y2 or xy2_or_x2.y)
            )
        end,
    }

    local metatable = {
        __index = prototype,
        __unm = function(xy)
            return _xy(-xy.x, -xy.y)
        end,
        __add = function(xy1, xy2)
            return _xy(xy1.x + xy2.x, xy1.y + xy2.y)
        end,
        __sub = function(xy1, xy2)
            return xy1 + (-xy2)
        end,
        __tostring = function(xy)
            return "(" .. xy.x .. "," .. xy.y .. ")"
        end,
    }

    _xy = setmetatable({}, {
        -- TODO: unused self?
        __call = function(self, x, y)
            return setmetatable(
                { x = x, y = y },
                metatable
            )
        end,
    })
end

_xy_0_0 = _xy(0, 0)
