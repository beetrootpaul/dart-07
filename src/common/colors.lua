-- -- -- -- -- -- -- --
-- misc/colors.lua   --
-- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- --
-- colors from standard palette:
-- (names below are taken from https://pico-8.fandom.com/wiki/Palette)
--

_palette_color_black = 0
_palette_color_dark_blue = 1
_palette_color_dark_purple = 2
_palette_color_dark_green = 3

_palette_color_brown = 4
_palette_color_dark_grey = 5
_palette_color_light_grey = 6
_palette_color_white = 7

_palette_color_red = 8
_palette_color_orange = 9
_palette_color_yellow = 10
_palette_color_green = 11

_palette_color_blue = 12
_palette_color_lavender = 13
_palette_color_pink = 14
_palette_color_light_peach = 15

-- -- -- -- -- -- -- -- -- -- -- --
-- colors from "secret"" palette:
-- (names below are taken from https://pico-8.fandom.com/wiki/Palette)
--

_palette_color_brownish_black = 128
_palette_color_darker_blue = 129
_palette_color_darker_purple = 130
_palette_color_blue_green = 131

_palette_color_dark_brown = 132
_palette_color_darker_grey = 133
_palette_color_medium_grey = 134
_palette_color_light_yellow = 135

_palette_color_dark_red = 136
_palette_color_dark_orange = 137
_palette_color_lime_green = 138
_palette_color_medium_green = 139

_palette_color_true_blue = 140
_palette_color_mauve = 141
_palette_color_dark_peach = 142
_palette_color_peach = 143

-- -- -- -- -- -- -- -- -- -- -- -- --
-- re-mapped colors used in this game
--

_color_0_black = 0
_color_1_dark_blue = 1
_color_2_darker_purple = 2
_color_3_blue_green = 3

-- 4
-- 5
_color_6_light_grey = 6
-- 7

-- 8
-- 9
-- 10
-- 11

_color_12_true_blue = 12
_color_13_mauve = 13
-- 14
_color_15_light_peach = 15

-- -- -- -- -- -- --
-- color re-mapping
--

function _remap_display_colors()
    local palette = {
        [_color_0_black] = _palette_color_black,
        [_color_1_dark_blue] = _palette_color_dark_blue,
        [_color_2_darker_purple] = _palette_color_darker_purple,
        [_color_3_blue_green] = _palette_color_blue_green,
        --
        [4] = _palette_color_black,
        [5] = _palette_color_black,
        [_color_6_light_grey] = _palette_color_light_grey,
        [7] = _palette_color_black,
        --
        [8] = _palette_color_black,
        [9] = _palette_color_black,
        [10] = _palette_color_black,
        [11] = _palette_color_black,
        --
        [_color_12_true_blue] = _palette_color_true_blue,
        [_color_13_mauve] = _palette_color_mauve,
        [10] = _palette_color_black,
        [11] = _palette_color_light_peach,
    }
    pal(palette, 1)
end
