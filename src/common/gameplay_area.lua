-- -- -- -- -- -- -- -- -- -- --
-- common/gameplay_area.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- gameplay area width (whole screen minus gui areas on the left and on the right)
_gaw = 96
-- gameplay area height (whole screen)
_gah = 128
-- gameplay area offset x (left part of the gui)
_gaox = 16

function _is_safely_outside_gameplay_area(xy)
    return xy.x < _gaox - _ts or
        xy.x > _gaox + _gaw + _ts or
        xy.y < -_ts or
        xy.y > _gah + _ts
end
