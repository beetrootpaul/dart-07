-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/sprites/static_sprite.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_static_sprite(params)
    local sprite_w = params.sprite_w
    local sprite_h = params.sprite_h
    local sprite_x = params.sprite_x
    local sprite_y = params.sprite_y

    return {
        draw = function(x, y)
            palt(_color_0_black, false)
            palt(_color_11_dark_green, true)
            sspr(
                sprite_x, sprite_y,
                sprite_w, sprite_h,
                x - sprite_w / 2, y - sprite_h / 2
            )
            palt()
        end,
    }
end