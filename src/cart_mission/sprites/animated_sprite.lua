-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/sprites/animated_sprite.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_animated_sprite(params)
    local sprite_w = params.sprite_w
    local sprite_h = params.sprite_h
    local sprite_xs = params.sprite_xs
    local sprite_y = params.sprite_y

    local frame = 1
    local max_frame = #sprite_xs

    return {
        animate = function()
            frame = _tni(frame, max_frame)
        end,

        draw = function(x, y, opts)
            opts = opts or {}
            
            if opts.flash_color then
                for c = 0, 15 do
                    pal(c, opts.flash_color, 0)
                end
            end

            sspr(
                sprite_xs[frame], sprite_y,
                sprite_w, sprite_h,
                x - sprite_w / 2, y - sprite_h / 2
            )

            if opts.flash_color then
                pal(0)
            end
        end,
    }
end