-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_outro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: boss spectacular destroy SFX

function new_screen_boss_outro(game, hud)
    local fade_out = new_fade("out", 30, 90)
    local screen_timer = new_timer(120)

    local max_unlocked_mission

    --

    local screen = {}

    function screen._init()
        -- TODO: describe DGET in API file
        -- TODO: encapsulate as _read_persisted_max_unlocked_mission(…)
        max_unlocked_mission = max(dget(0), 1)
        if max_unlocked_mission <= _m.mission_number then
            -- TODO: describe DSET in API file
            -- TODO: encapsulate as _persist_max_unlocked_mission(…)
            dset(0, _m.mission_number + 1)
        end
    end

    function screen._update()
        game._update()
        hud._update()
        fade_out._update()
        screen_timer._update()
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        hud._draw {
            player_health = game.health,
            shockwave_charges = game.shockwave_charges,
        }
        fade_out._draw()
    end

    function screen._post_draw()
        game._post_draw()

        if screen_timer.ttl <= 0 then
            if _m.mission_number < _max_mission_number then
                _load_mission_cart {
                    mission_number = _m.mission_number + 1,
                    health = game.health,
                    shockwave_charges = game.shockwave_charges,
                    triple_shot = game.triple_shot,
                    fast_shoot = game.fast_shoot,
                }
            else
                return new_screen_win()
            end
        end
    end

    return screen
end
