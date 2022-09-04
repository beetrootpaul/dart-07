-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/explosion.lua --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: polish it

function new_explosion(start_xy)
    return {
        has_finished = function()
            return false
        end,
        _update = function()
            -- TODO: ???
        end,
        _draw = function()
            circ(
                _gaox + start_xy.x,
                start_xy.y,
                6,
                _color_8_red
            )
        end,
    }
end

