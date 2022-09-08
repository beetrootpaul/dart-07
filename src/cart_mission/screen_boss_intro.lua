-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_intro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_boss_intro(params)
    local game = params.game
    local hud = params.hud

    local screen_frames = 180
    local boss_info_slide_frames = 50

    local boss_info = new_boss_info {
        slide_in_frames = boss_info_slide_frames,
        present_frames = screen_frames - 2 * boss_info_slide_frames,
        slide_out_frames = boss_info_slide_frames,
    }
    local screen_timer = new_timer(screen_frames)

    --

    local screen = {}

    function screen._init()
        -- TODO: boss music
        game.enter_boss_phase()
    end

    function screen._update()
        game._update()
        hud._update()
        boss_info._update()
        screen_timer._update()
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        hud._draw {
            player_health = game.player_health,
        }
        boss_info._draw()
    end

    function screen._post_draw()
        game._post_draw()

        if screen_timer.ttl <= 0 then
            return new_screen_boss_fight {
                game = game,
                hud = hud,
            }
        end
    end

    return screen
end
