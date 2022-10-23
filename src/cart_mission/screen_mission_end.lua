-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_mission_end.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- -- --
function new_screen_mission_end(game, hud)
    local fade_out, screen_timer, screen = new_fade("out", 30, 90), new_timer(120), {}
    --
    function screen._init()
        _music_fade_out()
    end
    
    function screen._update()
        game._update()
        hud._update()
        fade_out._update()
        screen_timer._update()
    end
    
    function screen._draw()
        cls(_m_bg_color)
        game._draw()
        hud._draw(game)
        fade_out._draw()
    end
    
    function screen._post_draw()
        game._post_draw()
        if screen_timer.ttl <= 0 then
            -- TODO: change 1 to 2 once mission is ready and 2 to 3 when mission 3 is ready as well 
            if _m_mission_number < 1 then
                _load_mission_cart(_m_mission_number + 1, game.health, game.shockwave_charges, game.fast_movement, game.fast_shoot, game.triple_shoot, game.score.raw_value())
            else
                return new_screen_over(game, true)
            end
        end
    end
    
    return screen
end
