-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_over.lua  --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_over(game)
    local high_score_so_far, current_score, fade_out, retry, proceed, screen = nil, nil, new_fade("out", 30), true, false, {}

    --

    function screen._init()
        high_score_so_far = dget(1)
        current_score = game.score
        dset(1, max(high_score_so_far, current_score))
    end

    function screen._update()
        if btnp(_button_up) or btnp(_button_down) then
            _sfx_play(_sfx_options_change)
            retry = not retry
        end

        if btnp(_button_x) then
            _music_fade_out()
            _sfx_play(_sfx_options_confirm)
            proceed = true
        end

        if proceed then
            fade_out._update()
        end
    end

    function screen._draw()
        cls(_color_0_black)

        print("try again (mission " .. _m.mission_number .. ")", 10, 40, retry and _color_6_light_grey or _color_14_mauve)
        print("back to title", 10, 60, retry and _color_14_mauve or _color_6_light_grey)

        -- TODO: polish it
        if current_score > high_score_so_far then
            print("new high score!", 10, 80, _color_6_light_grey)
            print(current_score, 70, 80, _color_9_dark_orange)
        else
            print("score:", 10, 80, _color_6_light_grey)
            print(current_score, 40, 80, _color_12_blue)
        end

        fade_out._draw()
    end

    function screen._post_draw()
        if fade_out.has_finished() then
            if retry then
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
