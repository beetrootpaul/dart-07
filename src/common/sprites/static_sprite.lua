-- -- -- -- -- -- -- -- -- -- -- -- --
-- common/sprites/static_sprite.lua --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_static_sprite(sprite_whxy_txt, from_left_top_corner)
    local w, h, x, y = unpack(split(sprite_whxy_txt))
    
    return new_animated_sprite(w, h, { x }, y, from_left_top_corner)
end