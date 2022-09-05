-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/collisions.lua   --
-- -- -- -- -- -- -- -- -- -- -- --

_collisions = {}

function _collisions.are_colliding(collision_circle_1, collision_circle_2)
    -- prevent collision detection if objects are outside top and bottom edges of the gameplay area
    if _is_y_not_within_gameplay_area(collision_circle_1.xy.y + collision_circle_1.r) or
        _is_y_not_within_gameplay_area(collision_circle_1.xy.y - collision_circle_1.r) or
        _is_y_not_within_gameplay_area(collision_circle_2.xy.y + collision_circle_2.r) or
        _is_y_not_within_gameplay_area(collision_circle_2.xy.y - collision_circle_2.r)
    then
        return false
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