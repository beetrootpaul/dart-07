-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/collisions.lua   --
-- -- -- -- -- -- -- -- -- -- -- --

_collisions = {}

function _collisions.are_colliding(collision_circle_1, collision_circle_2)
    local dx = collision_circle_2.xy.x - collision_circle_1.xy.x
    local dy = collision_circle_2.xy.y - collision_circle_1.xy.y
    local r1r2 = collision_circle_1.r + collision_circle_2.r
    return dx * dx + dy * dy <= r1r2 * r1r2
end

function _collisions._debug_draw_collision_circle(collision_circle)
    local adjusted_r = collision_circle.r - .5
    oval(
        collision_circle.xy.x - adjusted_r,
        collision_circle.xy.y - adjusted_r,
        collision_circle.xy.x + adjusted_r,
        collision_circle.xy.y + adjusted_r,
        _color_11_dark_green
    )
end