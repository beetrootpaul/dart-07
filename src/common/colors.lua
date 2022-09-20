-- -- -- -- -- -- -- --
-- common/colors.lua --
-- -- -- -- -- -- -- --

-- colors and their names are taken from: https://pico-8.fandom.com/wiki/Palette)

_color_0_black, _color_1_darker_blue, _color_2_darker_purple, _color_3_dark_green, _color_4_true_blue, _color_5_blue_green, _color_6_light_grey, _color_7_white, _color_8_red, _color_9_dark_orange, _color_10_unused, _color_11_transparent, _color_12_blue, _color_13_lavender, _color_14_mauve, _color_15_peach = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15

-- note: since tables are 1-indexed, color 0 is provided at the end of a table
_palette_display = split "129,130,3,140,131,6,7,8,137,10,11,12,13,141,143,0"
_palette_negative = split "6,13,14,9,15,1,0,12,4,11,10,8,2,3,5,7"