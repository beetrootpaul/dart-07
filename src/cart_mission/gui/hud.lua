-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/hud.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: score
-- TODO NEXT: edge case of a single frame of 0 hearths and strange bar initial line, during next cart loading
-- TODO: indicate acquired powerups, i.e. triple shot

function new_hud(params)
    local wait_frames = params.wait_frames
    local slide_in_frames = params.slide_in_frames

    local movement = new_movement_sequence_factory {
        sequence = {
            new_movement_fixed_factory {
                frames = wait_frames,
            },
            new_movement_to_target_factory {
                frames = slide_in_frames,
                target_x = 4,
                easing_fn = _easing_easeoutquart,
            },
        },
    }(_xy(-16, _vs))

    local bar_w = 16
    local boss_health_bar_margin = 2

    local hearth = new_static_sprite(6, 5, 40, 12, {
        from_left_top_corner = true,
    })
    local health_bar_start = new_static_sprite(8, 5, 40, 7, {
        from_left_top_corner = true,
    })
    local health_bar_segment = new_static_sprite(8, 7, 40, 0, {
        from_left_top_corner = true,
    })

    return {
        _update = function()
            movement._update()
        end,

        _draw = function(p)
            local player_health = p.player_health
            local boss_health = p.boss_health
            local boss_health_max = p.boss_health_max

            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)

            local xy = movement.xy.ceil()
            hearth._draw(xy.minus(-1, 10))
            health_bar_start._draw(xy.minus(0, 20))
            for i = 1, player_health do
                health_bar_segment._draw(xy.minus(0, 20 + i * 4))
            end

            -- TODO: polish it, add boss name above the bar
            if boss_health and boss_health_max then
                local health_fraction = boss_health / boss_health_max
                rectfill(
                    _gaox + boss_health_bar_margin,
                    2,
                    _gaox + boss_health_bar_margin + ceil(health_fraction * (_gaw - 2 * boss_health_bar_margin)) - 1,
                    4,
                    _color_8_red
                )
            end
        end,
    }
end