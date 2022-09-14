-- -- -- -- -- -- -- --
-- common/colors.lua --
-- -- -- -- -- -- -- --

-- colors and their names are taken from: https://pico-8.fandom.com/wiki/Palette)

_color_0_black, _color_1_darker_blue, _color_2_darker_purple, _color_3_dark_green = 0, 1, 2, 3
_color_4_true_blue, _color_5_blue_green, _color_6_light_grey, _color_7_white = 4, 5, 6, 7
_color_8_red, _color_9_dark_orange, _color_10_unused, _color_11_transparent = 8, 9, 10, 11
_color_12_blue, _color_13_lavender, _color_14_mauve, _color_15_peach = 12, 13, 14, 15

do
    local palette = {
        [_color_0_black] = 0,
        [_color_1_darker_blue] = 129,
        [_color_2_darker_purple] = 130,
        [_color_3_dark_green] = 3,
        --
        [_color_4_true_blue] = 140,
        [_color_5_blue_green] = 131,
        [_color_6_light_grey] = 6,
        [_color_7_white] = 7,
        --
        [_color_8_red] = 8,
        [_color_9_dark_orange] = 137,
        [_color_10_unused] = 10, -- show accidental usages of unused colors as yellow, which is not present in the chosen palette 
        [_color_11_transparent] = 11, -- use a bright green as transparency indicator in the sprite sheet
        --
        [_color_12_blue] = 12,
        [_color_13_lavender] = 13,
        [_color_14_mauve] = 141,
        [_color_15_peach] = 143,
    }

    function _remap_display_colors()
        pal(palette, 1)
    end
end

-- note: since tables are 1-indexed, color 0 is provided at the end of a table
_palette_negative = split "6,13,14,9,15,1,0,12,4,11,10,8,2,3,5,7"