-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_outro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: boss spectacular destroy SFX

function new_screen_boss_outro(params)
    local level = params.level
    local player = params.player
    local player_bullets = params.player_bullets
    local explosions = params.explosions
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local is_fast_shot_enabled = params.is_fast_shot_enabled
    local hud = params.hud

    local fade_out = new_fade("out", 30, 90)
    local screen_timer = new_timer(120)

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        if btn(_button_x) then
            player.fire {
                is_triple_shot_enabled = is_triple_shot_enabled,
                is_fast_shot_enabled = is_fast_shot_enabled,
            }
        end

        _flattened_for_each(
            { level },
            { player },
            player_bullets,
            explosions,
            { hud },
            { fade_out },
            { screen_timer },
            function(game_object)
                game_object._update()
            end
        )
    end

    function screen._draw()
        cls(_m.bg_color)
        clip(_gaox, 0, _gaw, _gah)
        _flattened_for_each(
            { level },
            player_bullets,
            { player },
            explosions,
            function(game_object)
                game_object._draw()
            end
        )
        clip()

        hud._draw {
            player_health = health,
        }

        fade_out._draw()
    end

    function screen._post_draw()
        _flattened_for_each(
            player_bullets,
            explosions,
            function(game_object, game_objects)
                if game_object.has_finished() then
                    del(game_objects, game_object)
                end
            end
        )

        if screen_timer.ttl <= 0 then
            if _m.mission_number < _max_mission_number then
                _load_mission_cart {
                    mission_number = _m.mission_number + 1,
                    health = health,
                    is_triple_shot_enabled = is_triple_shot_enabled,
                    is_fast_shot_enabled = is_fast_shot_enabled,
                }
            else
                return new_screen_win()
            end
        end
    end

    return screen
end
