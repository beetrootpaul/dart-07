-- -- -- -- -- -- -- --
-- common/colors.lua --
-- -- -- -- -- -- -- --

-- -- -- -- -- -- -- -- -- -- -- --
-- colors from standard palette:
-- (names below are taken from https://pico-8.fandom.com/wiki/Palette)
--

do

    local _palette_color_black = 0
    local _palette_color_dark_blue = 1
    local _palette_color_dark_purple = 2
    local _palette_color_dark_green = 3

    local _palette_color_brown = 4
    local _palette_color_dark_grey = 5
    local _palette_color_light_grey = 6
    local _palette_color_white = 7

    local _palette_color_red = 8
    local _palette_color_orange = 9
    local _palette_color_yellow = 10
    local _palette_color_green = 11

    local _palette_color_blue = 12
    local _palette_color_lavender = 13
    local _palette_color_pink = 14
    local _palette_color_light_peach = 15

    -- -- -- -- -- -- -- -- -- -- -- --
    -- colors from "secret"" palette:
    -- (names below are taken from https://pico-8.fandom.com/wiki/Palette)
    --

    local _palette_color_brownish_black = 128
    local _palette_color_darker_blue = 129
    local _palette_color_darker_purple = 130
    local _palette_color_blue_green = 131

    local _palette_color_dark_brown = 132
    local _palette_color_darker_grey = 133
    local _palette_color_medium_grey = 134
    local _palette_color_light_yellow = 135

    local _palette_color_dark_red = 136
    local _palette_color_dark_orange = 137
    local _palette_color_lime_green = 138
    local _palette_color_medium_green = 139

    local _palette_color_true_blue = 140
    local _palette_color_mauve = 141
    local _palette_color_dark_peach = 142
    local _palette_color_peach = 143

    -- -- -- -- -- -- -- -- -- -- -- -- --
    -- re-mapped colors used in this game
    --

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
            -- TODO: finalize custom palette
            [4] = _palette_color_black,
            [5] = _palette_color_black,
            [_color_6_light_grey] = _palette_color_light_grey,
            [_color_7_blue] = _palette_color_blue,
            --
            [_color_8_red] = _palette_color_red,
            [_color_9_dark_orange] = _palette_color_dark_orange,
            -- TODO: finalize custom palette
            [10] = _palette_color_black,
            [_color_11_dark_green] = _palette_color_dark_green,
            --
            [_color_12_true_blue] = _palette_color_true_blue,
            [_color_13_mauve] = _palette_color_mauve,
            [_color_14_lavender] = _palette_color_lavender,
            [_color_15_peach] = _palette_color_peach,
        }
        pal(palette, 1)
    end
    
end
