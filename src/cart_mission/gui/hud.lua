-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/hud.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: score
-- TODO: edge case of a single frame of 0 hearths and strange bar initial line, during next cart loading
-- TODO: indicate acquired powerups, i.e. triple shot

function new_hud(params)
    local wait_frames = params.wait_frames
    local slide_in_frames = params.slide_in_frames

    local wait_timer = new_timer(wait_frames)

    local slide_in_timer = new_timer(slide_in_frames)
    -- TODO: externalize?
    local slide_in_x_initial = -16
    local slide_in_x_target = 4

    local bar_w = 16
    local boss_health_bar_margin = 2

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
        _update = function()
            if phase == "wait" then
                if wait_timer.ttl > 0 then
                    wait_timer._update()
                else
                    phase = "slide_in"
                end
            elseif phase == "slide_in" then
                if slide_in_timer.ttl > 0 then
                    slide_in_timer._update()
                end
            end
        end,

        _draw = function(p)
            local player_health = p.player_health
            local boss_health = p.boss_health
            local boss_health_max = p.boss_health_max

            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)

            if phase == "slide_in" then
                local x = ceil(_easing_lerp(
                    slide_in_x_initial,
                    slide_in_x_target,
                    _easing_easeoutquart(slide_in_timer.passed_ratio())
                ))
                hearth._draw(x + 1, _vs - 10)
                health_bar_start._draw(x, _vs - 20)
                for i = 1, player_health do
                    health_bar_segment._draw(x, _vs - 20 - i * 4)
                end
            end

            -- TODO: polish it, add boss name above the bar
            if boss_health and boss_health_max then
                local health_ratio = boss_health / boss_health_max
                rectfill(
                    _gaox + boss_health_bar_margin,
                    2,
                    _gaox + boss_health_bar_margin + ceil(health_ratio * (_gaw - 2 * boss_health_bar_margin)) - 1,
                    4,
                    _color_8_red
                )
            end
        end,
    }
end