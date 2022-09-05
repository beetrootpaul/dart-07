-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_intro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: allow player to shoot during during mission intro and boss intro

function new_screen_boss_intro(params)
    local level = params.level
    local player = params.player
    local player_bullets = params.player_bullets
    local explosions = params.explosions
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local boss = new_boss {
        boss_properties = _m.boss_properties(),
        intro_frames = 90,
        intro_start_xy = _xy(_gaw / 2, -120),
        start_xy = _xy(_gaw / 2, 20, 20),
    }

    local boss_info = new_boss_info {
        slide_in_frames = 25,
        present_frames = 40,
        slide_out_frames = 25,
    }
    local screen_timer = new_timer(90)

    --

    local screen = {}

    function screen._init()
        -- TODO: boss music
    end

    function screen._update()
        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        level._update()
        _go_update(player_bullets)
        _go_update(explosions)
        player._update()
        boss._update { no_fight = true }
        hud._update()
        boss_info._update()
        screen_timer._update()
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                _go_draw(player_bullets)
                boss._draw()
                player._draw()
                _go_draw(explosions)
            end,
        }
        hud._draw {
            player_health = health,
        }
        boss_info._draw()
    end

    function screen._post_draw()
        _go_delete_finished(player_bullets)
        _go_delete_finished(explosions)

        if screen_timer.ttl <= 0 then
            return new_screen_boss_fight {
                level = level,
                player = player,
                boss = boss,
                player_bullets = player_bullets,
                explosions = explosions,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                hud = hud,
            }
        end
    end

    return screen
end
