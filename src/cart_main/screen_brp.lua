-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_brp.lua   --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: fade type: dark -> normal -> dark

function new_screen_brp()
    local screen_timer = new_timer(60)

    --

    local screen = {}

    function screen._init()
        -- TODO: music
    end

    function screen._update()
        screen_timer._update()
    end

    function screen._draw()
        cls(_color_0_black)

        print("todo brp", 14, 30, _color_13_mauve)
    end

    function screen._post_draw()
        if screen_timer.ttl <= 0 then
            return new_screen_title()
        end
    end

    return screen
end
