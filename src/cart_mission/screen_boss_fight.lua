-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_fight.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_boss_fight(game, hud)
    local screen = {}

    function screen._init()
        game.start_boss_fight()
    end

    function screen._update()
        game._update()
        hud._update()
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        hud._draw {
            player_health = game.health,
            shockwave_charges = game.shockwave_charges,
            boss_health = game.boss_health,
            boss_health_max = game.boss_health_max,
        }
    end

    function screen._post_draw()
        game._post_draw()

        if game.is_boss_defeated() then
            return new_screen_boss_outro(game, hud)
        end

        if game.health <= 0 then
            return new_screen_defeat(game, hud)
        end
    end

    return screen
end
