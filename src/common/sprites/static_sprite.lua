-- -- -- -- -- -- -- -- -- -- -- -- --
-- common/sprites/static_sprite.lua --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_static_sprite(sprite_whxy_txt, params)
    params = params or {}
    local w, h, x, y = unpack(split(sprite_whxy_txt))
    
    return new_animated_sprite(w, h, { x }, y, params)
end