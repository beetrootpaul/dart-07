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
_color_7_white = 7

_color_8_red = 8
_color_9_dark_orange = 9
_color_10_blue = 10
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
        [_color_7_white] = 7,
        --
        [_color_8_red] = 8,
        [_color_9_dark_orange] = 137,
        [_color_10_blue] = 12,
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

-- TODO: polish this palette
-- note: since tables are 1-indexed, color 0 is provided at the end of a table
_palette_negative = split "15,11,13,4,5,14,0,10,12,8,2,9,3,6,1,7"