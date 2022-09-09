-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/hud.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: score

function new_hud(params)
    local player_health_bar_movement = new_movement_sequence_factory {
        new_movement_fixed_factory {
            frames = params.wait_frames
        },
        new_movement_to_target_factory {
            frames = params.slide_in_frames,
            target_x = 0,
            easing_fn = _easing_easeoutquart,
        },
    }(_xy(-20, _vs))

    local bar_w = 16
    local boss_health_bar_margin = 2

    local heart = new_static_sprite(6, 5, 40, 24, {
        from_left_top_corner = true,
    })
    local health_bar_start = new_static_sprite(8, 5, 40, 19, {
        from_left_top_corner = true,
    })
    local health_bar_segment_full = new_static_sprite(8, 11, 40, 8, {
        from_left_top_corner = true,
    })
    local health_bar_segment_empty = new_static_sprite(1, 11, 40, 8, {
        from_left_top_corner = true,
    })
    local health_bar_segment_joint = new_static_sprite(8, 2, 40, 6, {
        from_left_top_corner = true,
    })

    return {
        _update = function()
            player_health_bar_movement._update()
        end,

        _draw = function(p)
            local player_health = p.player_health
            local boss_health = p.boss_health
            local boss_health_max = p.boss_health_max

            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)
            -- DEBUG:
            --rectfill(0, 0, bar_w - 1, _vs - 1, _color_3_blue_green)
            --rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_3_blue_green)

            local xy = player_health_bar_movement.xy.ceil()
            heart._draw(xy.minus(12, 10))
            health_bar_start._draw(xy.minus(13, 20))
            for segment = 1, _health_max do
                (player_health >= segment and health_bar_segment_full or health_bar_segment_empty)._draw(xy.minus(13, 20 + segment * 8))
                if player_health > segment then
                    health_bar_segment_joint._draw(xy.minus(13, 20 + segment * 8 - 1))
                end
            end

            -- TODO: polish it
            if boss_health and boss_health_max then
                local health_fraction = boss_health / boss_health_max
                rectfill(
                    _gaox + boss_health_bar_margin,
                    4,
                    _gaox + boss_health_bar_margin + ceil(health_fraction * (_gaw - 2 * boss_health_bar_margin)) - 1,
                    5,
                    _color_8_red
                )
            end
        end,
    }
end