-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/collisions.lua   --
-- -- -- -- -- -- -- -- -- -- -- --

_collisions = {}

function _collisions.are_colliding(collision_circle_1, collision_circle_2)
    -- prevent collision detection if objects are outside top and bottom edges of the gameplay area
    -- (4 is an arbitrary chosen offset to increase a chance player will see what they hit before it disappears) 
    if collision_circle_1.xy.y + collision_circle_1.r < 4 or
        collision_circle_1.xy.y - collision_circle_1.r > _gah - 4 or
        collision_circle_2.xy.y + collision_circle_2.r < 4 or
        collision_circle_2.xy.y - collision_circle_2.r > _gah - 4
    then
        return false
    end

    -- actual collision check
    local distance = collision_circle_2.xy.minus(collision_circle_1.xy)
    local r1r2 = collision_circle_1.r + collision_circle_2.r
    return distance.x * distance.x + distance.y * distance.y <= r1r2 * r1r2
end

function _collisions._debug_draw_collision_circle(collision_circle)
    local adjusted_r = collision_circle.r - .5
    oval(
        _gaox + collision_circle.xy.x - adjusted_r,
        collision_circle.xy.y - adjusted_r,
        _gaox + collision_circle.xy.x + adjusted_r,
        collision_circle.xy.y + adjusted_r,
        _color_11_dark_green
    )
end