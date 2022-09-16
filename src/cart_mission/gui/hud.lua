-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/hud.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: score

function new_hud(params)
    local slide_in_offset = new_movement_sequence_factory {
        new_movement_fixed_factory {
            frames = params.wait_frames,
        },
        new_movement_to_target_factory {
            frames = params.slide_in_frames,
            target_x = 0,
            easing_fn = _easing_easeoutquart,
        },
    }(_xy(-20, 0))

    local bar_w = 16
    local boss_health_bar_margin = 2

    local sprite_opts = { from_left_top_corner = true }

    local heart = new_static_sprite(6, 5, 40, 24, sprite_opts)
    local health_bar_start = new_static_sprite(8, 5, 40, 19, sprite_opts)
    local health_bar_segment_full = new_static_sprite(8, 11, 40, 8, sprite_opts)
    local health_bar_segment_empty = new_static_sprite(1, 11, 40, 8, sprite_opts)

    local shockwave = new_static_sprite(7, 6, 48, 24, sprite_opts)
    local shockwave_bar_start = new_static_sprite(8, 1, 48, 23, sprite_opts)
    local shockwave_bar_segment_full = new_static_sprite(8, 21, 48, 2, sprite_opts)
    local shockwave_bar_segment_empty = new_static_sprite(2, 21, 54, 2, sprite_opts)

    local boss_health_bar_start = new_static_sprite(4, 4, 40, 0, sprite_opts)
    local boss_health_bar_end = new_static_sprite(4, 4, 44, 0, sprite_opts)

    return {
        _update = function()
            slide_in_offset._update()
        end,

        _draw = function(p)
            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)
            -- DEBUG:
            --rectfill(0, 0, bar_w - 1, _vs - 1, _color_5_blue_green)
            --rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_5_blue_green)

            local xy = _xy(-_gaox + 3, _vs - 16).plus(slide_in_offset.xy.ceil())
            heart._draw(xy.plus(1, 6))
            for segment = 1, _health_max do
                (p.player_health >= segment and health_bar_segment_full or health_bar_segment_empty)._draw(xy.minus(0, 4 + segment * 8))
            end
            -- we have to draw health_bar_start after health_bar_segment_full in order to cover 1st segment's joint with black pixels
            health_bar_start._draw(xy.minus(0, 4))

            xy = _xy(_gaw + 5, _vs - 16).minus(slide_in_offset.xy.ceil())
            shockwave._draw(xy.plus(0, 6))
            shockwave_bar_start._draw(xy)
            for segment = 1, _shockwave_charges_max do
                if p.shockwave_charges >= segment then
                    shockwave_bar_segment_full._draw(xy.minus(0, segment * 21))
                else
                    shockwave_bar_segment_empty._draw(xy.minus(-6, segment * 21))
                end
            end

            if p.boss_health and p.boss_health_max then
                local health_fraction = p.boss_health / p.boss_health_max
                boss_health_bar_start._draw(_xy(boss_health_bar_margin, boss_health_bar_margin))
                boss_health_bar_end._draw(_xy(_gaw - boss_health_bar_margin - 4, boss_health_bar_margin))
                line(
                    _gaox + boss_health_bar_margin + 2,
                    boss_health_bar_margin + 2,
                    _gaox + _gaw - boss_health_bar_margin - 3,
                    boss_health_bar_margin + 2,
                    _color_14_mauve
                )
                if health_fraction > 0 then
                    line(
                        _gaox + boss_health_bar_margin + 2,
                        boss_health_bar_margin + 1,
                        _gaox + boss_health_bar_margin + 2 + flr(health_fraction * (_gaw - 2 * boss_health_bar_margin - 4)) - 1,
                        boss_health_bar_margin + 1,
                        _color_8_red
                    )
                end
            end
        end,
    }
end