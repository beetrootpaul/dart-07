-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_defeat.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_screen_defeat(game, hud)
    local screen_frames = 120
    local fade_out_frames = 30

    local fade_out = new_fade("out", fade_out_frames, screen_frames - fade_out_frames)
    local screen_timer = new_timer(screen_frames)

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        game._update()
        hud._update()
        fade_out._update()
        screen_timer._update()
    end

    function screen._draw()
        cls(_m.bg_color)
        game._draw()
        hud._draw {
            player_health = game.health,
            shockwave_charges = game.shockwave_charges,
        }
        fade_out._draw()
    end

    function screen._post_draw()
        game._post_draw()

        if screen_timer.ttl <= 0 then
            return new_screen_over()
        end
    end

    return screen
end
