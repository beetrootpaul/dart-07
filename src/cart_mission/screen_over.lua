-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_over.lua  --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_over(game, is_win)
    local got_high_score, fade_in, fade_out, proceed, screen = false, new_fade("in", 30), new_fade("out", 30), false, {}

    local retry = true

    local function draw_button(text, w, x, y, selected)
        -- button shape
        sspr(
            selected and (is_win and 37 or 35) or 36, 12,
            1, 12,
            x, y,
            w, 12
        )

        -- button text
        print(
            text,
            x + 4, y + 3,
            is_win and _color_5_blue_green or _color_14_mauve
        )

        -- "x" press incentive
        if selected then
            new_static_sprite(
                "15,6,56," .. (is_win and 12 or 0) + _alternating_0_and_1() * 6,
                true
            )._draw(x + w - 16 - _gaox, y + 13)
        end
    end

    --

    function screen._init()
        if is_win then
            -- this music is available on the last mission's cart only
            music(2)
        end

        local current_score = game.score.raw_value()
        local high_score_so_far = dget(0)
        got_high_score = current_score > high_score_so_far
        dset(0, max(high_score_so_far, current_score))
        -- DEBUG:
        --got_high_score = true
    end

    function screen._update()
        if not is_win then
            if btnp(_button_up) or btnp(_button_down) then
                _sfx_play(_sfx_options_change)
                retry = not retry
            end
        end

        if btnp(_button_x) then
            _music_fade_out()
            _sfx_play(_sfx_options_confirm)
            proceed = true
        end

        if proceed then
            fade_out._update()
        else
            fade_in._update()
        end
    end

    function screen._draw()
        cls(is_win and _color_3_dark_green or _color_2_darker_purple)

        -- heading
        _centered_print(
            is_win and "you \-fmade \-fit!" or "game \-fover",
            22,
            _color_7_white,
            is_win and _color_5_blue_green or _color_8_red
        )

        -- score
        local score_base_y = got_high_score and 42 or 47
        _centered_print("your \-fscore", score_base_y, _color_7_white)
        game.score._draw(52, score_base_y + 10, _color_7_white, is_win and _color_5_blue_green or _color_14_mauve)
        if got_high_score then
            _centered_print("new \-fhigh \-fscore!", score_base_y + 20, is_win and _color_15_peach or _color_9_dark_orange)
        end

        -- buttons
        if not is_win then
            draw_button("try \-fmission \-f" .. _m.mission_number .. " \-fagain", 80, 24, 81, retry)
        end
        draw_button("go \-fto \-ftitle \-fscreen", 80, 24, is_win and 85 or 103, not retry or is_win)

        fade_in._draw()
        fade_out._draw()
    end

    function screen._post_draw()
        if fade_out.has_finished() then
            if not is_win and retry then
                extcmd("reset")
            else
                _load_main_cart {
                    preselected_mission_number = _m.mission_number,
                }
            end
        end
    end

    return screen
end
