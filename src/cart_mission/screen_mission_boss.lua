-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_mission_boss.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_boss(game, hud)
    local boss_info_frames, boss_info_slide_frames, music_start_timer, screen = 180, 50, _noop_game_object, {}

    local boss_info = new_sliding_info {
        text_2 = _m_boss_name,
        main_color = _color_8_red,
        slide_in_frames = boss_info_slide_frames,
        present_frames = boss_info_frames - 2 * boss_info_slide_frames,
        slide_out_frames = boss_info_slide_frames,
        -- DEBUG:
        --slide_in_frames = 8,
        --present_frames = 0,
        --slide_out_frames = 8,
    }

    --

    function screen._init()
        _music_fade_out()
        music_start_timer = new_timer(60, function()
            music(_m_mission_boss_music)
        end)
        game.enter_boss_phase()
    end

    function screen._update()
        game._update()
        hud._update()
        boss_info._update()
        music_start_timer._update()
    end

    function screen._draw()
        cls(_m_bg_color)
        game._draw()
        hud._draw(game)
        boss_info._draw()
    end

    function screen._post_draw()
        game._post_draw()

        if boss_info.has_finished() then
            boss_info = _noop_game_object
            game.start_boss_fight()
        end

        if game.health <= 0 then
            return new_screen_defeat(game, hud)
        end

        if game.is_boss_defeated() then
            return new_screen_mission_end(game, hud)
        end
    end

    return screen
end
