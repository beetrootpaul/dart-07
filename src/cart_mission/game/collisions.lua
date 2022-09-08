-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/collisions.lua --
-- -- -- -- -- -- -- -- -- -- -- -- --

_collisions = {}

function _collisions.are_colliding(collision_circle_1, collision_circle_2, opts)
    opts = opts or {}
    
    if not opts.ignore_gameplay_area_check then
        if _is_collision_circle_nearly_outside_top_edge_of_gameplay_area(collision_circle_1) or
            _is_collision_circle_nearly_outside_top_edge_of_gameplay_area(collision_circle_2)
        then
            return false
        end
    end

    -- actual collision check
    local distance = collision_circle_2.xy.minus(collision_circle_1.xy)
    local r1r2 = collision_circle_1.r + collision_circle_2.r
    return distance.x * distance.x + distance.y * distance.y <= r1r2 * r1r2
end

-- DEBUG:
function _collisions._debug_draw_collision_circle(collision_circle)
    oval(
        _round(_gaox + collision_circle.xy.x - collision_circle.r),
        _round(collision_circle.xy.y - collision_circle.r),
        _round(_gaox + collision_circle.xy.x + collision_circle.r),
        _round(collision_circle.xy.y + collision_circle.r),
        _color_11_dark_green
    )
end