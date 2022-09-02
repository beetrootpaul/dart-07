-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/sprites/static_sprite.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_static_sprite(sprite_w, sprite_h, sprite_x, sprite_y, opts)
    opts = opts or {}
    local from_left_top_corner = opts.from_left_top_corner
    local transparent_color = opts.transparent_color

    return {
        _draw = function(x, y, opts)
            opts = opts or {}

            if not from_left_top_corner then
                x = x - sprite_w / 2
                y = y - sprite_h / 2
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
                x, y
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