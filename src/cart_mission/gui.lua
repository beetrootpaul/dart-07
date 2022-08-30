-- -- -- -- -- -- -- -- --
-- cart_mission/gui.lua --
-- -- -- -- -- -- -- -- --

function new_gui()
    local bar_w = 16

    local hearth = new_static_sprite {
        sprite_w = 6,
        sprite_h = 5,
        sprite_x = 0,
        sprite_y = 53,
        from_left_top_corner = true,
    }
    local health_bar_start = new_static_sprite {
        sprite_w = 8,
        sprite_h = 5,
        sprite_x = 0,
        sprite_y = 48,
        from_left_top_corner = true,
    }
    local health_bar_segment = new_static_sprite {
        sprite_w = 8,
        sprite_h = 7,
        sprite_x = 0,
        sprite_y = 41,
        from_left_top_corner = true,
    }

    return {
        draw = function(health)
            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)

            hearth.draw(4, _vs - 10)

            health_bar_start.draw(3, _vs - 20)
            for i = 1, health do
                health_bar_segment.draw(3, _vs - 20 - i * 4) --4 + (i - 1) * 4)
            end
        end,
    }
end