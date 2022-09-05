-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_fight.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: consider some explosions along the fight

function new_screen_boss_fight(params)
    local level = params.level
    local player = params.player
    local boss = params.boss
    local player_bullets = params.player_bullets
    local explosions = params.explosions
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local boss_bullets = {}

    -- TODO: duplicated code
    local function handle_player_damage()
        -- TODO NEXT: powerups retrieval after live lost?
        -- TODO: SFX
        is_triple_shot_enabled = false
        -- TODO NEXT: player defeat explosion
        -- TODO: VFX of disappearing health segment
        health = health - 1
        if health > 0 then
            player.start_invincibility_after_damage()
        end
    end

    -- TODO: a little bit of duplicated code
    local function handle_collisions()
        local player_cc = player.collision_circle()

        -- player bullets vs boss + player vs boss
        for _, boss_cc in pairs(boss.collision_circles()) do
            for __, player_bullet in pairs(player_bullets) do
                if not boss.has_finished() then
                    if _collisions.are_colliding(player_bullet.collision_circle(), boss_cc) then
                        -- TODO: SFX
                        -- TODO: big explosion if no longer alive
                        boss.take_damage()
                        player_bullet.destroy()
                        -- TODO: magnetised score items?
                    end
                end
            end
            if not boss.has_finished() and not player.is_invincible_after_damage() then
                if _collisions.are_colliding(player_cc, boss_cc) then
                    handle_player_damage()
                end
            end
        end

        -- player vs boss bullets
        for _, boss_bullet in pairs(boss_bullets) do
            if not player.is_invincible_after_damage() then
                if _collisions.are_colliding(boss_bullet.collision_circle(), player_cc) then
                    handle_player_damage()
                end
            end
        end
    end

    --

    local screen = {}

    function screen._init()
        boss.enter_phase_main()
        boss.set_on_bullets_spawned(function(bullets)
            for _, b in pairs(bullets) do
                add(boss_bullets, b)
            end
        end)
        boss.set_on_entered_next_phase(function(collision_circles)
            -- TODO: small explosions SFX
            for _, cc in pairs(collision_circles) do
                add(explosions, new_explosion(cc.xy, .75 * cc.r))
            end
        end)
        boss.set_on_destroyed(function(collision_circles)
            -- TODO: explosions SFX
            for _, cc in pairs(collision_circles) do
                add(explosions, new_explosion(cc.xy, .8 * cc.r))
                add(explosions, new_explosion(cc.xy, 1.4 * cc.r, 4 + flr(rnd(44))))
                add(explosions, new_explosion(cc.xy, 1.8 * cc.r, 12 + flr(rnd(36))))
                add(explosions, new_explosion(cc.xy, 3.5 * cc.r, 30 + flr(rnd(18))))
                add(explosions, new_explosion(cc.xy, 5 * cc.r, 50 + flr(rnd(6))))
            end
        end)
        player.set_on_bullets_spawned(function(bullets)
            for _, b in pairs(bullets) do
                add(player_bullets, b)
            end
        end)
    end

    function screen._update()
        -- TODO: REMOVE THIS
        if btnp(_button_o) then
            if _m.mission_number < _max_mission_number then
                _load_mission_cart {
                    mission_number = _m.mission_number,
                    health = _health_default,
                    is_triple_shot_enabled = false,
                }
            else
                _load_main_cart()
            end
        end

        player.set_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))

        if btn(_button_x) then
            player.fire {
                is_triple_shot_enabled = is_triple_shot_enabled,
            }
        end

        _flattened_for_each(
            { level },
            { player },
            player_bullets,
            { boss },
            boss_bullets,
            explosions,
            { hud },
            function(game_object)
                game_object._update()
            end
        )

        handle_collisions()
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                _flattened_for_each(
                    player_bullets,
                    boss_bullets,
                    { boss },
                    { player },
                    explosions,
                    function(game_object)
                        game_object._draw()
                    end
                )
            end,
        }
        hud._draw {
            player_health = health,
            boss_health = boss.health or nil,
            boss_health_max = boss.health_max or nil,
        }

        -- DEBUG:
        --for _, boss_cc in pairs(boss.collision_circles()) do
        --    _collisions._debug_draw_collision_circle(boss_cc)
        --end
        --_flattened_for_each(
        --    { player },
        --    player_bullets,
        --    boss_bullets,
        --    function(game_object)
        --        _collisions._debug_draw_collision_circle(game_object.collision_circle())
        --    end
        --)
    end

    function screen._post_draw()
        _flattened_for_each(
            player_bullets,
            boss_bullets,
            explosions,
            function(game_object, game_objects)
                if game_object.has_finished() then
                    del(game_objects, game_object)
                end
            end
        )

        if boss.has_finished() then
            -- TODO NEXT: draft version of exploding enemies and boss
            -- TODO: nice post-boss-destroy visuals before transitioning to the next cart
            return new_screen_boss_outro {
                level = level,
                player = player,
                player_bullets = player_bullets,
                explosions = explosions,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                hud = hud,
            }
        end

        if health <= 0 then
            -- TODO NEXT: game over
            -- TODO NEXT: wait a moment after death
            _load_main_cart()
        end
    end

    return screen
end
