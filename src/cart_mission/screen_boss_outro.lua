-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_outro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: boss spectacular destroy VFX and SFX
-- TODO: win screen after all 3 levels

function new_screen_boss_outro(params)
    local level = params.level
    local player = params.player
    local health = params.health
    local hud = params.hud

    local screen_timer = new_timer(90)

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        level._update()
        player._update()
        hud._update()
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
    end

    function screen._post_draw()
        -- TODO: fade screen out
        -- TODO: fade next screen in
        if screen_timer.ttl <= 0 then
            if _m.mission_number < _max_mission_number then
                _load_mission_cart {
                    mission_number = _m.mission_number + 1,
                    health = health,
                }
            else
                _load_main_cart()
            end
        end
    end

    return screen
end
