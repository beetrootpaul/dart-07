-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_intro.lua --
-- -- -- -- -- -- -- -- -- -- -- --

-- TODO: try to recreate cool text motion effect
-- TODO: polish it
-- TODO: allow player to shoot during during mission intro and boss intro

function new_screen_intro(params)
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled

    local fade_frames = 20
    local mission_info_slide_frames = 50
    local screen_frames = 200

    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)
    local player = new_player()
    local hud = new_hud {
        wait_frames = 190,
        slide_in_frames = 40,
    }
    local mission_info = new_mission_info {
        wait_frames = fade_frames,
        slide_in_frames = mission_info_slide_frames,
        present_frames = screen_frames - fade_frames - 2 * mission_info_slide_frames,
        slide_out_frames = mission_info_slide_frames,
    }
    local fade_in = new_fade("in", fade_frames)
    local screen_timer = new_timer(screen_frames)

    --

    local screen = {}

    function screen._init()
        -- TODO: music  
    end

    function screen._update()
        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        _flattened_for_each(
            { level },
            { player },
            { hud },
            { mission_info },
            { fade_in },
            { screen_timer },
            function(game_object)
                game_object._update()
            end
        )
    end

    function screen._draw()
        cls(_m.bg_color)
        clip(_gaox, 0, _gaw, _gah)
        level._draw()
        player._draw()
        clip()
        
        hud._draw {
            player_health = health,
        }
        mission_info._draw()
        fade_in._draw()
    end

    function screen._post_draw()
        if screen_timer.ttl <= 0 then
            return new_screen_enemies {
                level = level,
                player = player,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                hud = hud,
            }
        end
    end

    return screen
end
