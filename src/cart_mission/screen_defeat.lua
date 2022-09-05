-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_defeat.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_defeat(params)
    local level = params.level
    local enemies = params.enemies
    local boss = params.boss -- optional
    local enemy_bullets = params.enemy_bullets
    local boss_bullets = params.boss_bullets
    local explosions = params.explosions
    local health = params.health
    local hud = params.hud

    local screen_frames = 120
    local fade_out_frames = 20

    local fade_out = new_fade("out", fade_out_frames, screen_frames - fade_out_frames)
    local screen_timer = new_timer(screen_frames)

    --

    local screen = {}

    function screen._init()
        -- TODO: music?
    end

    function screen._update()
        _flattened_for_each(
            { level },
            enemies,
            { boss },
            enemy_bullets,
            boss_bullets,
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
            enemies,
            { boss },
            enemy_bullets,
            boss_bullets,
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
            enemies,
            enemy_bullets,
            boss_bullets,
            explosions,
            function(game_object, game_objects)
                if game_object.has_finished() then
                    del(game_objects, game_object)
                end
            end
        )

        if screen_timer.ttl <= 0 then
            -- TODO NEXT: game over screen
            _load_main_cart()
        end
    end

    return screen
end
