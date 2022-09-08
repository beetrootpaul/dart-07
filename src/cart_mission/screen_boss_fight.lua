-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_boss_fight.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_boss_fight(params)
    local game = params.game
    local hud = params.hud

    --

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
            player_health = game.player_health,
            boss_health = game.boss_health,
            boss_health_max = game.boss_health_max,
        }
    end

    function screen._post_draw()
        game._post_draw()

        if game.is_boss_defeated() then
            return new_screen_boss_outro {
                game = game,
                hud = hud,
            }
        end

        if game.player_health <= 0 then
            return new_screen_defeat {
                game = game,
                hud = hud,
            }
        end
    end

    return screen
end
