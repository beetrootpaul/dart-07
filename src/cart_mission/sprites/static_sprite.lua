-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/sprites/static_sprite.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: consider consolidating with new_animated_sprite
function new_static_sprite(sprite_w, sprite_h, sprite_x, sprite_y, params)
    params = params or {}
    local from_left_top_corner = params.from_left_top_corner
    local transparent_color = params.transparent_color

    return {
        _draw = function(xy, opts)
            opts = opts or {}

            if not from_left_top_corner then
                xy = xy.minus(sprite_w / 2, sprite_h / 2)
            end

            if transparent_color then
                palt(_color_0_black, false)
                palt(transparent_color, true)
            end

            if opts.flash_color then
                for c = 0, 15 do
                    pal(c, opts.flash_color, 0)
                end
            end

            sspr(
                sprite_x, sprite_y,
                sprite_w, sprite_h,
                _gaox + xy.x, xy.y
            )

            if opts.flash_color then
                pal(0)
            end

            if transparent_color then
                palt()
            end
        end,
    }
end