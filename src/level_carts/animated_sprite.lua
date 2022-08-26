-- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/animated_sprite.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_animated_sprite(params)
    local sprite_w = params.sprite_w
    local sprite_h = params.sprite_h
    local sprite_xs = params.sprite_xs
    local sprite_y = params.sprite_y
    
    local frame = 1
    local max_frame = #sprite_xs

    return {
        update = function()
            frame = _tni(frame, max_frame)
        end,

        draw = function(x, y)
            sspr(sprite_xs[frame], sprite_y, sprite_w, sprite_h, x, y)
        end,
    }
end