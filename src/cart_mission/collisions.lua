-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/collisions.lua   --
-- -- -- -- -- -- -- -- -- -- -- --

_collisions = {}

function _collisions.are_colliding(collision_circle_1, collision_circle_2)
    local dx = collision_circle_2.x - collision_circle_1.x
    local dy = collision_circle_2.y - collision_circle_1.y
    local r1r2 = collision_circle_1.r + collision_circle_2.r
    return dx * dx + dy * dy <= r1r2 * r1r2
end

function _collisions._debug_draw_collision_circle(collision_circle)
    oval(
        collision_circle.x - (collision_circle.r - .5),
        collision_circle.y - (collision_circle.r - .5),
        collision_circle.x + (collision_circle.r - .5),
        collision_circle.y + (collision_circle.r - .5),
        _color_11_dark_green
    )
end