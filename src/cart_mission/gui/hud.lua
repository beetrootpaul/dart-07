-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/hud.lua   --
-- -- -- -- -- -- -- -- -- -- --

function new_hud(params)
    local slide_in_offset = new_movement_sequence_factory {
        new_movement_fixed_factory {
            frames = params.wait_frames,
            -- DEBUG:
            --frames = 0,
        },
        new_movement_to_target_factory {
            frames = params.slide_in_frames,
            target_x = 0,
            easing_fn = _easing_easeoutquart,
            -- DEBUG:
            --frames = 0,
        },
    }(_xy(-20, 0))

    local bar_w, boss_health_bar_margin = 16, 2

    local function new_hud_sprite(sprite_whxy_txt)
        return new_static_sprite(sprite_whxy_txt, { from_left_top_corner = true })
    end

    local heart, health_bar_start, health_bar_segment_full, health_bar_segment_empty = new_hud_sprite "6,5,40,24", new_hud_sprite "8,5,40,19", new_hud_sprite "8,9,40,10", new_hud_sprite "1,9,40,10"
    local shockwave, shockwave_bar_start, shockwave_bar_segment_full, shockwave_bar_segment_empty = new_hud_sprite "7,6,48,24", new_hud_sprite "8,1,48,23", new_hud_sprite "8,16,48,7", new_hud_sprite "2,16,54,7"
    local ship_indicator = new_hud_sprite "3,5,40,4"
    local boss_health_bar_start, boss_health_bar_end = new_hud_sprite "4,4,40,0", new_hud_sprite "4,4,44,0"

    return {
        _update = slide_in_offset._update,

        _draw = function(game)
            rectfill(0, 0, bar_w - 1, _vs - 1, _color_0_black)
            rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_0_black)
            -- DEBUG:
            --rectfill(0, 0, bar_w - 1, _vs - 1, _color_5_blue_green)
            --rectfill(_vs - bar_w, 0, _vs - 1, _vs - 1, _color_5_blue_green)

            -- health bar
            local xy = _xy(-_gaox + 3, _vs - 16).plus(slide_in_offset.xy.ceil())
            heart._draw(xy.plus(1, 6))
            for segment = 1, _health_max do
                (game.health >= segment and health_bar_segment_full or health_bar_segment_empty)._draw(xy.minus(0, 4 + segment * 6))
            end
            -- we have to draw health_bar_start after health_bar_segment_full in order to cover 1st segment's joint with black pixels
            health_bar_start._draw(xy.minus(0, 4))

            -- mission progress
            local mission_progress_h = 35
            local mission_progress_x = _gaox + xy.x + 5
            line(
                mission_progress_x,
                4,
                mission_progress_x,
                3 + mission_progress_h,
                _color_13_lavender
            )
            ship_indicator._draw(xy.minus(
                -4,
                77 + game.mission_progress_fraction() * (mission_progress_h - 3)
            ))


            -- shockwave charges
            xy = _xy(_gaw + 5, _vs - 16).minus(slide_in_offset.xy.ceil())
            shockwave._draw(xy.plus(0, 6))
            shockwave_bar_start._draw(xy)
            for segment = 1, _shockwave_charges_max do
                if game.shockwave_charges >= segment then
                    shockwave_bar_segment_full._draw(xy.minus(0, segment * 16))
                else
                    shockwave_bar_segment_empty._draw(xy.minus(-6, segment * 16))
                end
            end

            -- score
            local score_text = game.score.as_6_digits_text_with_extra_zero()
            local score_text_x = xy.x + 17
            for i = 1, #score_text do
                local score_text_y = -2 + i * 6
                print(
                    "8",
                    score_text_x,
                    score_text_y,
                    _color_2_darker_purple
                )
                print(
                    score_text[i],
                    score_text_x,
                    score_text_y,
                    _color_6_light_grey
                )
            end

            -- boss health
            -- (hack to optimize tokens: we set game.boss_health_max only when boss enters
            -- fight phase, even if we update game.boss_health earlier on every frame;
            -- thanks to that we can easily detect if it's time to show boss' health bar)
            if game.boss_health_max then
                local health_fraction = game.boss_health / game.boss_health_max
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