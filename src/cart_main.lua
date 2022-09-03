-- -- -- -- -- -- --
-- cart_main.lua  --
-- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    -- -- TODO NEXT: game over screen here with score from the failed/succeeded mission?
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

-- TODO NEXT: tutorial screen? press X to shoot, arrows to fly
-- TODO NEXT: screen shake?
-- TODO NEXT: menu item to disable screen shake?

-- TODO NEXT: "hit stop"?

-- TODO NEXT: push enemies and boss on damage?

-- TODO NEXT: lighten/darken transition between screens? Or dithered "fillp" one?

-- TODO: menu music
-- TODO: music per stage
-- TODO: music per boss stage

-- TODO: balancing: powerup distributions 
-- TODO: balancing: enemy speed 
-- TODO: balancing: enemy bullet timer 
-- TODO: balancing: enemy bullet movement 
-- TODO: balancing: enemy movement 
-- TODO: balancing: player bullet timer 
-- TODO: balancing: player bullet movement 
-- TODO: balancing: boss movement, including easing fns
-- TODO: balancing: boss bullet timer
-- TODO: balancing: boss bullet movement

-- TODO: consider license other than MIT
