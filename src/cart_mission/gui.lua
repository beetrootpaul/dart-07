-- -- -- -- -- -- -- -- --
-- cart_mission/gui.lua --
-- -- -- -- -- -- -- -- --

function new_gui()
    local bar_h = 16

    local armor_text = new_text_4px("armor")
    local armor_indicator_border_left = new_static_sprite {
        sprite_w = 3,
        sprite_h = 5,
        sprite_x = 0,
        sprite_y = 48,
        from_left_top_corner = true,
    }
    local armor_indicator = new_static_sprite {
        sprite_w = 5,
        sprite_h = 5,
        sprite_x = 3,
        sprite_y = 48,
        from_left_top_corner = true,
    }

    return {
        draw = function(armor)
            rectfill(0, 0, _vs - 1, bar_h - 1, _color_0_black)
            rectfill(0, _vs - bar_h, _vs - 1, _vs - 1, _color_0_black)

            armor_text.draw(2, 2, _color_13_mauve)
            line(2, 7, 2 + armor_text.w, 7, _color_13_mauve)
            palt(_color_0_black, true)
            armor_indicator_border_left.draw(2, 8)
            for a = 1, armor do
                armor_indicator.draw(4 + (a - 1) * 4, 8)
            end
            palt()
        end,
    }
end