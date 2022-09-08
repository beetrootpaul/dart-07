-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_enemies_fight.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_enemies_fight(params)
    local game = params.game
    local hud = params.hud

    --

    local screen = {}

    function screen._init()
        game.enter_enemies_phase()
    end

    function screen._update()
        game.set_player_movement(btn(_button_left), btn(_button_right), btn(_button_up), btn(_button_down))
        if btn(_button_x) then
            game.player_fire()
        end

        game._update()
        hud._update()
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        hud._draw {
            player_health = game.player_health,
        }
    end

    function screen._post_draw()
        game._post_draw()

        if game.is_ready_to_enter_boss_phase() then
            return new_screen_boss_intro {
                game = game,
                hud = hud,
            }
        end

        if game.player_health <= 0 then
            -- TODO: should we keep remaining player bullets visible? Should we allow them to hit boss after intro (even if practically impossible)? If not, should we nicely destroy them?
            return new_screen_defeat {
                game = game,
                hud = hud,
            }
        end
    end

    return screen
end
