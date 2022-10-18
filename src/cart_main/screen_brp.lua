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
        music(0)
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
        local brp_color = _color_15_peach
        if fade_in_timer.passed_fraction() < .33 then
            bg_pattern = 0x0000
            brp_color = _color_2_darker_purple
        elseif fade_in_timer.passed_fraction() < .66 then
            bg_pattern = 0x0f00
            brp_color = _color_14_mauve
        elseif fade_in_timer.passed_fraction() < 1 then
            bg_pattern = 0x0f0f
            brp_color = _color_13_lavender
        elseif present_timer.passed_fraction() < 1 then
        elseif fade_out_timer.passed_fraction() < .33 then
            bg_pattern = 0x0f0f
            brp_color = _color_13_lavender
        elseif fade_out_timer.passed_fraction() < .66 then
            bg_pattern = 0x0f00
            brp_color = _color_14_mauve
        else
            bg_pattern = 0x0000
            brp_color = _color_2_darker_purple
        end
        if fade_out_timer.passed_fraction() < 1 then
            pal(_color_10_unused, brp_color)
            sspr(99, 114, 29, 14, _vs - 29 * 2 / 2, _vs - 14 * 2 / 2, 29 * 2, 14 * 2)
            pal(1)
        end
    end
    
    function screen._post_draw()
        if screen_timer.ttl <= 0 then
            return new_screen_title(1, false, true, false)
        end
    end
    
    return screen
end
