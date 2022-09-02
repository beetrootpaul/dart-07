-- -- -- -- -- -- --
-- cart_main.lua  --
-- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    -- TODO: ?
    --local score = tonum(split(stat(6))[1]) or 2
    --local number = tonum(split(stat(6))[2]) or -3

    current_screen = new_screen_title()
end

function _update()
    next_screen = current_screen._post_draw()

    if next_screen then
        current_screen = next_screen
        current_screen._init()
    end

    current_screen._update()
end

function _draw()
    current_screen._draw()

    _remap_display_colors()
end

-- TODO: screen shake?

-- TODO: "hit stop"?

-- TODO: push enemies and boss on damage?

-- TODO: lighten/darken transition between screens? Or dithered "fillp" one?

-- TODO: menu music
-- TODO: music per stage
-- TODO: music per boss stage

-- TODO: remove unused sprites
-- TODO: remove unused SFXs
-- TODO: remove unused music

-- TODO: consider license other than MIT
