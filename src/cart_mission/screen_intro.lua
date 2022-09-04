-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_intro.lua --
-- -- -- -- -- -- -- -- -- -- -- --

-- TODO: polish it

function new_screen_intro(params)
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled

    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)
    local player = new_player()
    local hud = new_hud {
        wait_frames = 85,
        slide_in_frames = 20,
    }
    local mission_info = new_mission_info {
        slide_in_frames = 25,
        present_frames = 40,
        slide_out_frames = 25,
    }
    local screen_timer = new_timer(90)

    --

    local screen = {}

    function screen._init()
        -- TODO: music  
    end

    function screen._update()
        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        level._update()
        player._update()
        hud._update()
        mission_info._update()
        screen_timer._update()
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                player._draw()
            end,
        }
        hud._draw {
            player_health = health,
        }
        mission_info._draw()
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
