-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_enemies_fight.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_enemies_fight(game, hud)
    local screen = {}

    function screen._init()
        game.enter_enemies_phase()
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
        }
    end

    function screen._post_draw()
        game._post_draw()

        if game.is_ready_to_enter_boss_phase() then
            return new_screen_boss_intro(game, hud)
        end

        if game.health <= 0 then
            return new_screen_defeat(game, hud)
        end
    end

    return screen
end
