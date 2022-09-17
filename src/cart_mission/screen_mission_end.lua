-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_mission_end.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_mission_end(game, hud)
    local fade_out, screen_timer, max_unlocked_mission, screen = new_fade("out", 30, 90), new_timer(120), nil, {}

    --

    function screen._init()
        _music_fade_out()

        max_unlocked_mission = max(dget(0), 1)
        if max_unlocked_mission <= _m.mission_number then
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
