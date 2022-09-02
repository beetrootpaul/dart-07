-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_intro.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: GUI boss announcement
-- TODO: boss slide in

function new_screen_boss_intro(params)
    local level = params.level
    local player = params.player
    local player_bullets = params.player_bullets
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled
    local hud = params.hud

    local boss = new_boss {
        boss_properties = _m.boss_properties(),
    }
    
    local boss_info = new_boss_info {
        slide_in_frames = 25,
        present_frames = 40,
        slide_out_frames = 25,
    }
    local screen_timer = new_timer(90)

    --

    local screen = {}

    function screen._init()
        -- TODO: boss music
    end

    function screen._update()
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

        level._update()
        for _, player_bullet in pairs(player_bullets) do
            player_bullet._update()
        end
        player._update()
        boss._update { no_fight = true }
        hud._update()
        boss_info._update()
        screen_timer._update()
    end

    function screen._draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level._draw {
            draw_within_level_bounds = function()
                for _, player_bullet in pairs(player_bullets) do
                    player_bullet._draw()
                end
                boss._draw()
                player._draw()
            end,
        }
        hud._draw {
            player_health = health,
        }
        boss_info._draw()
    end

    function screen._post_draw()
        for index, player_bullet in pairs(player_bullets) do
            if player_bullet.has_finished() then
                del(player_bullets, player_bullet)
            end
        end
        
        if screen_timer.ttl <= 0 then
            return new_screen_boss_fight {
                level = level,
                player = player,
                boss = boss,
                health = health,
                is_triple_shot_enabled = is_triple_shot_enabled,
                hud = hud,
            }
        end
    end

    return screen
end
