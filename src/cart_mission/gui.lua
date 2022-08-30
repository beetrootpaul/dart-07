-- -- -- -- -- -- -- -- --
-- cart_mission/gui.lua --
-- -- -- -- -- -- -- -- --

function new_gui()
    local bar_w = 16

    -- TODO: externalize?
    local slide_in_frame = 0
    local slide_in_frame_max = 16
    local slide_in_x_initial = -16
    local slide_in_x_target = 4

    --local easing_fn = _easing_linear
    local easing_fn = _easing_easeoutquart
    --local easing_fn = _easing_easeoutovershoot
    --local easing_fn = _easing_easeinoutelastic

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
        animate = function()
            slide_in_frame = min(slide_in_frame + 1, slide_in_frame_max)
        end,
        draw = function(health)
            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)

            local slide_in_factor = easing_fn(slide_in_frame / slide_in_frame_max)
            local x = ceil(_easing_lerp(slide_in_x_initial, slide_in_x_target, slide_in_factor))

            hearth.draw(x + 1, _vs - 10)
            health_bar_start.draw(x, _vs - 20)
            for i = 1, health do
                health_bar_segment.draw(x, _vs - 20 - i * 4)
            end
        end,
    }
end