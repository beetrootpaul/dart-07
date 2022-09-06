-- -- -- -- -- -- -- -- -- -- --
-- common/gameplay_area.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- gameplay area width (whole screen minus gui areas on the left and on the right)
_gaw = 96
-- gameplay area height (whole screen)
_gah = 128
-- gameplay area offset x (left part of the gui)
_gaox = 16

-- calculations below assume xy is in relation to (_gaox, 0) point
function _is_safely_outside_gameplay_area(xy)
    return xy.x < -_ts or
        xy.x > _gaw + _ts or
        xy.y < -_ts or
        xy.y > _gah + _ts
end

function _is_y_not_within_gameplay_area(y)
    -- 3 is an arbitrary chosen offset to increase a chance player will 
    -- see what they hit before it disappears
    return y < 2 or y > _gah - 2
end
