-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_intro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO NEXT: allow player to shoot during during mission intro and boss intro?

function new_screen_boss_intro(params)
    local level = params.level
    local player = params.player
    local player_bullets = params.player_bullets
    local explosions = params.explosions
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local screen_frames = 180
    local boss_info_slide_frames = 50

    local boss = new_boss {
        boss_properties = _m.boss_properties(),
        intro_frames = 180,
        intro_start_xy = _xy(_gaw / 2, -120),
        start_xy = _xy(_gaw / 2, 20, 20),
    }
    local boss_info = new_boss_info {
        slide_in_frames = boss_info_slide_frames,
        present_frames = screen_frames - 2 * boss_info_slide_frames,
        slide_out_frames = boss_info_slide_frames,
    }
    local screen_timer = new_timer(screen_frames)

    --

    local screen = {}

    function screen._init()
        -- TODO: boss music
    end

    function screen._update()
        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        boss._update { no_fight = true }

        _flattened_for_each(
            { level },
            { player },
            player_bullets,
            explosions,
            { hud },
            { boss_info },
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
            { boss },
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
        boss_info._draw()
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
