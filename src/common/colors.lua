-- -- -- -- -- -- -- --
-- common/colors.lua --
-- -- -- -- -- -- -- --

-- colors and their names are taken from: https://pico-8.fandom.com/wiki/Palette)

_color_0_black = 0
_color_1_dark_blue = 1
_color_2_darker_purple = 2
_color_3_blue_green = 3

-- TODO: finalize custom palette
-- 4
-- 5
_color_6_light_grey = 6
_color_7_blue = 7

_color_8_red = 8
_color_9_dark_orange = 9
-- TODO: finalize custom palette
-- 10
_color_11_dark_green = 11

_color_12_true_blue = 12
_color_13_mauve = 13
_color_14_lavender = 14
_color_15_peach = 15

do
    local palette = {
        [_color_0_black] = 0,
        [_color_1_dark_blue] = 1,
        [_color_2_darker_purple] = 130,
        [_color_3_blue_green] = 131,
        --
        -- TODO: finalize custom palette
        [4] = 0,
        [5] = 0,
        [_color_6_light_grey] = 6,
        [_color_7_blue] = 12,
        --
        [_color_8_red] = 8,
        [_color_9_dark_orange] = 137,
        -- TODO: finalize custom palette
        [10] = 0,
        [_color_11_dark_green] = 3,
        --
        [_color_12_true_blue] = 140,
        [_color_13_mauve] = 141,
        [_color_14_lavender] = 13,
        [_color_15_peach] = 143,
    }

    function _remap_display_colors()
        pal(palette, 1)
    end
end
    
