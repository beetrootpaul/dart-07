-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_mission_boss.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_boss(game, hud)
    local screen_frames = 180
    local boss_info_slide_frames = 50

    local boss_info = new_boss_info {
        slide_in_frames = boss_info_slide_frames,
        present_frames = screen_frames - 2 * boss_info_slide_frames,
        slide_out_frames = boss_info_slide_frames,
    }

    --

    local screen = {}

    function screen._init()
        -- TODO NEXT: music fade in?
        music(_m.mission_boss_music)
        game.enter_boss_phase()
    end

    function screen._update()
        game._update()
        hud._update()

        if boss_info then
            boss_info._update()
        end
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        hud._draw {
            player_health = game.health,
            shockwave_charges = game.shockwave_charges,
            boss_health = (not boss_info) and game.boss_health or nil,
            boss_health_max = (not boss_info) and game.boss_health_max or nil,
        }

        if boss_info then
            boss_info._draw()
        end
    end

    function screen._post_draw()
        game._post_draw()

        if boss_info and boss_info.has_finished() then
            boss_info = nil
            game.start_boss_fight()
        end

        if game.is_boss_defeated() then
            return new_screen_mission_end(game, hud)
        end

        if game.health <= 0 then
            return new_screen_defeat(game, hud)
        end
    end

    return screen
end
