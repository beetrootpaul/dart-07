-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- common/sprites/animated_sprite.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_animated_sprite(sprite_w, sprite_h, sprite_xs, sprite_y, from_left_top_corner)
    local frame, max_frame = 1, #sprite_xs

    return {
        _update = function()
            frame = _tni(frame, max_frame)
        end,

        _draw = function(xy_or_x, y)
            local xy = y and _xy(xy_or_x, y) or xy_or_x

            xy = (from_left_top_corner and xy or xy.minus(sprite_w / 2, sprite_h / 2))

            palt(_color_0_black, false)
            palt(_color_11_transparent, true)

            sspr(
                sprite_xs[frame],
                sprite_y,
                sprite_w,
                sprite_h,
            -- flr(value + .5) is an equivalent of a regular rounding
                flr(_gaox + xy.x + .5),
                flr(xy.y + .5)
            )

            palt()
        end,
    }
end