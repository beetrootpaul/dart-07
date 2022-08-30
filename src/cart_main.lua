-- -- -- -- -- -- --
-- cart_main.lua  --
-- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    -- TODO: ?
    --local score = tonum(split(stat(6))[1]) or 2
    --local number = tonum(split(stat(6))[2]) or -3
    --next_screen = new_screen_title(score, number)

    -- TODO: start with a title screen
    next_screen = new_screen_mission_select()
end

function _update()
    if current_screen ~= next_screen then
        next_screen.init()
    end
    current_screen = next_screen
    next_screen = current_screen.update()
end

function _draw()
    current_screen.draw()

    _remap_display_colors()
end

-- TODO: boss mechanic

-- TODO: screen shake?

-- TODO: "hit stop"?

-- TODO: lighten/darken transition between screens? Or dithered "fillp" one?

-- TODO: menu music
-- TODO: music per stage
-- TODO: music per boss stage

-- TODO: remove unused sprites
-- TODO: remove unused SFXs
-- TODO: remove unused music

-- TODO: consider license other than MIT
