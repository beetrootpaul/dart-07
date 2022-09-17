-- -- -- -- -- -- -- -- -- -- --
-- common/gameplay_area.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- - gameplay area width (whole screen minus gui areas on the left and on the right)
-- - gameplay area height (whole screen)
-- - gameplay area offset x (left part of the gui)
_gaw, _gah, _gaox = 96, 128, 16

-- calculations below assume xy is in relation to (_gaox, 0) point
function _is_safely_outside_gameplay_area(xy)
    return xy.x < -_ts or
        xy.x > _gaw + _ts or
        xy.y < -_ts or
        xy.y > _gah + _ts
end

function _is_collision_circle_nearly_outside_top_edge_of_gameplay_area(collision_circle)
    return collision_circle.xy.y + collision_circle.r < 3
end
