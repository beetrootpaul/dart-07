-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/sprites/static_sprite.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_static_sprite(params)
    local sprite_w = params.sprite_w
    local sprite_h = params.sprite_h
    local sprite_x = params.sprite_x
    local sprite_y = params.sprite_y
    
    local from_left_top_corner = params.from_left_top_corner
    local transparent_color = params.transparent_color

    return {
        draw = function(x, y, opts)
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