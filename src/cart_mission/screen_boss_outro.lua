-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_outro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: boss spectacular destroy VFX
-- TODO: boss spectacular destroy SFX
-- TODO: win screen after all 3 levels

function new_screen_boss_outro(params)
    local level = params.level
    local player = params.player
    local player_bullets = params.player_bullets
    local explosions = params.explosions
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local fade_out = new_fade("out", 10, 80)
    local screen_timer = new_timer(90)

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        level._update()
        player._update()
        _go_update(player_bullets)
        _go_update(explosions)
        hud._update()

        fade_out._update()
        screen_timer._update()
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                _go_draw(player_bullets)
                player._draw()
                _go_draw(explosions)
            end,
        }

        hud._draw {
            player_health = health,
        }

        fade_out._draw()
    end

    function screen._post_draw()
        _go_delete_finished(player_bullets)
        _go_delete_finished(explosions)

        -- TODO: fade screen out
        -- TODO: fade next screen in
        if screen_timer.ttl <= 0 then
            if _m.mission_number < _max_mission_number then
                _load_mission_cart {
                    mission_number = _m.mission_number + 1,
                    health = health,
                    is_triple_shot_enabled = is_triple_shot_enabled,
                }
            else
                _load_main_cart()
            end
        end
    end

    return screen
end
