-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_mission_main.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_main(params)
    local game = new_game {
        health = params.health,
        shockwave_charges = params.shockwave_charges,
        triple_shot = params.triple_shot,
        fast_shoot = params.fast_shoot,
        score = params.score,
        -- DEBUG:
        --health = 7,
        --shockwave_charges = 3,
        --triple_shot = true,
        --fast_shoot = true,
    }

    local fade_in_frames, sliding_info_slide_frames, screen_frames = 30, 50, 200

    local hud = new_hud {
        wait_frames = screen_frames - 10,
        slide_in_frames = 40,
    }
    local mission_info = new_sliding_info {
        text_1 = "mission \-f" .. _m.mission_number,
        text_2 = _m.mission_name,
        main_color = _m.mission_info_color,
        wait_frames = fade_in_frames,
        slide_in_frames = sliding_info_slide_frames,
        present_frames = screen_frames - fade_in_frames - 2 * sliding_info_slide_frames,
        slide_out_frames = sliding_info_slide_frames,
        -- DEBUG:
        --slide_in_frames = 8,
        --present_frames = 0,
        --slide_out_frames = 8,
    }
    local fade_in, screen = new_fade("in", fade_in_frames), {}

    --

    function screen._init()
        music(_m.mission_main_music)
    end

    function screen._update()
        game._update()
        hud._update()

        if mission_info then
            mission_info._update()
        end
        if fade_in then
            fade_in._update()
        end
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        hud._draw(game)
        --hud._draw {
        --    player_health = game.health,
        --    shockwave_charges = game.shockwave_charges,
        --    score = game.score,
        --}

        if mission_info then
            mission_info._draw()
        end
        if fade_in then
            fade_in._draw()
        end
    end

    function screen._post_draw()
        game._post_draw()

        if fade_in and fade_in.has_finished() then
            fade_in = nil
        end

        if mission_info and mission_info.has_finished() then
            mission_info = nil
            game.enter_enemies_phase()
        end

        if game.is_ready_to_enter_boss_phase() then
            return new_screen_mission_boss(game, hud)
        end

        if game.health <= 0 then
            return new_screen_defeat(game, hud)
        end
    end

    return screen
end
