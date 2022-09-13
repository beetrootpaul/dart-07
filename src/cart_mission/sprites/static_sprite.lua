-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/sprites/static_sprite.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_static_sprite(sprite_w, sprite_h, sprite_x, sprite_y, params)
    params = params or {}
    
    return new_animated_sprite(sprite_w, sprite_h, { sprite_x }, sprite_y, {
        from_left_top_corner = params.from_left_top_corner,
    })
end