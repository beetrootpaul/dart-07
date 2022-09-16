-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_brp.lua   --
-- -- -- -- -- -- -- -- -- -- --

function new_screen_brp()
    local screen_frames = 150
    local fade_frames = 24
    local screen_timer = new_timer(screen_frames)
    local fade_in_timer = new_timer(fade_frames)
    local present_timer = new_timer(screen_frames - 2 * fade_frames - 20)
    local fade_out_timer = new_timer(fade_frames)

    --

    local screen = {}

    function screen._init()
    end

    function screen._update()
        screen_timer._update()

        if fade_in_timer.ttl > 0 then
            fade_in_timer._update()
        elseif present_timer.ttl > 0 then
            present_timer._update()
        else
            fade_out_timer._update()
        end
    end

    function screen._draw()
        cls(_color_0_black)

        local bg_pattern = 0xffff
        local sy = 72
        if fade_in_timer.passed_fraction() < .33 then
            bg_pattern = 0x0000
            sy = 114
        elseif fade_in_timer.passed_fraction() < .66 then
            bg_pattern = 0x0f00
            sy = 100
        elseif fade_in_timer.passed_fraction() < 1 then
            bg_pattern = 0x0f0f
            sy = 86
        elseif present_timer.passed_fraction() < 1 then
        elseif fade_out_timer.passed_fraction() < .33 then
            bg_pattern = 0x0f0f
            sy = 86
        elseif fade_out_timer.passed_fraction() < .66 then
            bg_pattern = 0x0f00
            sy = 100
        else
            bg_pattern = 0x0000
            sy = 114
        end

        if fade_out_timer.passed_fraction() < 1 then
            sspr(
                99, sy,
                29, 14,
                (_vs - 29 * 2) / 2, (_vs - 14 * 2) / 2,
                29 * 2, 14 * 2
            )
        end
    end

    function screen._post_draw()
        if screen_timer.ttl <= 0 then
            return new_screen_select_mission {
                preselected_mission_number = 1,
            }
        end
    end

    return screen
end
