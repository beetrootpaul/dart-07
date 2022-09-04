-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_outro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: boss spectacular destroy VFX and SFX
-- TODO: win screen after all 3 levels

function new_screen_boss_outro(params)
    local level = params.level
    local player = params.player
    local player_bullets = params.player_bullets
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local fade_out = new_fade("out", 10, 50)
    local screen_timer = new_timer(60)

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        level._update()
        player._update()
        for _, player_bullet in pairs(player_bullets) do
            player_bullet._update()
        end
        hud._update()

        fade_out._update()
        screen_timer._update()
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                for _, player_bullet in pairs(player_bullets) do
                    player_bullet._draw()
                end
                player._draw()
            end,
        }
        
        hud._draw {
            player_health = health,
        }

        fade_out._draw()
    end

    function screen._post_draw()
        _delete_finished_from(player_bullets)

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
