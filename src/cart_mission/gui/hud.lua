-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/hud.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: score

function new_hud(params)
    local wait_frames = params.wait_frames
    local slide_in_frames = params.slide_in_frames

    local wait_timer = new_timer(wait_frames)

    local slide_in_timer = new_timer(slide_in_frames)
    -- TODO: externalize?
    local slide_in_x_initial = -16
    local slide_in_x_target = 4

    local bar_w = 16

    local hearth = new_static_sprite {
        sprite_w = 6,
        sprite_h = 5,
        sprite_x = 40,
        sprite_y = 12,
        from_left_top_corner = true,
    }
    local health_bar_start = new_static_sprite {
        sprite_w = 8,
        sprite_h = 5,
        sprite_x = 40,
        sprite_y = 7,
        from_left_top_corner = true,
    }
    local health_bar_segment = new_static_sprite {
        sprite_w = 8,
        sprite_h = 7,
        sprite_x = 40,
        sprite_y = 0,
        from_left_top_corner = true,
    }

    -- phase: wait -> slide_in
    local phase = "wait"

    return {
        animate = function()
            if phase == "wait" then
                if wait_timer.ttl > 0 then
                    wait_timer.advance()
                else
                    phase = "slide_in"
                end
            elseif phase == "slide_in" then
                if slide_in_timer.ttl > 0 then
                    slide_in_timer.advance()
                end
            end
        end,

        draw = function(health)
            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)

            if phase == "slide_in" then
                local x = ceil(_easing_lerp(
                    slide_in_x_initial,
                    slide_in_x_target,
                    _easing_easeoutquart(slide_in_timer.passed_ratio())
                ))
                hearth.draw(x + 1, _vs - 10)
                health_bar_start.draw(x, _vs - 20)
                for i = 1, health do
                    health_bar_segment.draw(x, _vs - 20 - i * 4)
                end
            end
        end,
    }
end