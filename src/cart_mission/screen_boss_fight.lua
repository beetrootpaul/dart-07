-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_fight.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_boss_fight(params)
    local level = params.level
    local player = params.player
    local boss = params.boss
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local player_bullets = {}
    local boss_bullets = {}

    -- TODO: duplicated code
    local throttled_fire_player_bullet = new_throttle(6, function()
        -- TODO: SFX
        add(player_bullets, new_player_bullet { start_xy = player.xy.plus(0, -4) })
        if is_triple_shot_enabled then
            -- TODO: different SFX
            add(player_bullets, new_player_bullet { start_xy = player.xy.plus(-5, -2) })
            add(player_bullets, new_player_bullet { start_xy = player.xy.plus(5, -2) })
        end
    end)

    -- TODO: duplicated code
    local function handle_player_damage()
        -- TODO: powerups retrieval after live lost?
        -- TODO: SFX
        is_triple_shot_enabled = false
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
                        -- TODO: blinking boss if still alive
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
        boss.set_on_bullets_spawned(function(spawned_boss_bullets)
            for _, seb in pairs(spawned_boss_bullets) do
                add(boss_bullets, seb)
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

        -- TODO: duplicated code
        if btn(_button_down) then
            player.set_vertical_movement("d")
        elseif btn(_button_up) then
            player.set_vertical_movement("u")
        else
            player.set_vertical_movement("-")
        end
        if btn(_button_left) then
            player.set_horizontal_movement("l")
        elseif btn(_button_right) then
            player.set_horizontal_movement("r")
        else
            player.set_horizontal_movement("-")
        end

        if btn(_button_x) then
            throttled_fire_player_bullet.invoke()
        end

        level._update()
        player._update()
        for _, player_bullet in pairs(player_bullets) do
            player_bullet._update()
        end
        boss._update()
        for _, boss_bullet in pairs(boss_bullets) do
            boss_bullet._update()
        end
        throttled_fire_player_bullet._update()
        hud._update()

        handle_collisions()
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                for _, player_bullet in pairs(player_bullets) do
                    player_bullet._draw()
                end
                for _, boss_bullet in pairs(boss_bullets) do
                    boss_bullet._draw()
                end
                boss._draw()
                player._draw()
            end,
        }
        hud._draw {
            player_health = health,
            boss_health = boss.health or nil,
            boss_health_max = boss.health_max or nil,
        }

        -- DEBUG:
        _collisions._debug_draw_collision_circle(player.collision_circle())
        for _, boss_cc in pairs(boss.collision_circles()) do
            _collisions._debug_draw_collision_circle(boss_cc)
        end
        for _, player_bullet in pairs(player_bullets) do
            _collisions._debug_draw_collision_circle(player_bullet.collision_circle())
        end
        for _, boss_bullet in pairs(boss_bullets) do
            _collisions._debug_draw_collision_circle(boss_bullet.collision_circle())
        end
    end

    function screen._post_draw()
        for index, player_bullet in pairs(player_bullets) do
            if player_bullet.has_finished() then
                del(player_bullets, player_bullet)
            end
        end
        for index, boss_bullet in pairs(boss_bullets) do
            if boss_bullet.has_finished() then
                del(boss_bullets, boss_bullet)
            end
        end

        if boss.has_finished() then
            -- TODO: nice post-boss-destroy visuals before transitioning to the next cart
            return new_screen_boss_outro {
                level = level,
                player = player,
                player_bullets = player_bullets,
                boss_bullets = boss_bullets,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                hud = hud,
            }
        end

        if health <= 0 then
            -- TODO: game over
            -- TODO: wait a moment after death
            _load_main_cart()
        end
    end

    return screen
end
