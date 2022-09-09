-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_mission_intro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: try to recreate cool text motion effect
-- TODO: polish it
-- TODO: polish mission names and boss names

function new_screen_mission_intro(params)
    local game = new_game {
        health = params.health,
        shockwave_charges = params.shockwave_charges,
        triple_shot = params.triple_shot,
        fast_shoot = params.fast_shoot,
    }

    local fade_in_frames = 30
    local mission_info_slide_frames = 50
    local screen_frames = 200

    local hud = new_hud {
        wait_frames = screen_frames - 10,
        slide_in_frames = 40,
    }
    local mission_info = new_mission_info {
        wait_frames = fade_in_frames,
        slide_in_frames = mission_info_slide_frames,
        present_frames = screen_frames - fade_in_frames - 2 * mission_info_slide_frames,
        slide_out_frames = mission_info_slide_frames,
    }
    local fade_in = new_fade("in", fade_in_frames)

    local screen_timer = new_timer(screen_frames)

    --

    local screen = {}

    function screen._init()
        -- TODO: music  
    end

    function screen._update()
        game._update()
        mission_info._update()
        hud._update()
        fade_in._update()
        screen_timer._update()
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        mission_info._draw()
        hud._draw {
            player_health = game.health,
        }
        fade_in._draw()
    end

    function screen._post_draw()
        game._post_draw()

        if screen_timer.ttl <= 0 then
            return new_screen_enemies_fight {
                game = game,
                hud = hud,
            }
        end
    end

    return screen
end
