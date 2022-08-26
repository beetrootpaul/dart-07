-- -- -- -- -- -- -- -- -- --
-- main_cart/main_cart.lua --
-- -- -- -- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    -- TODO: ?
    --local score = tonum(split(stat(6))[1]) or 2
    --local number = tonum(split(stat(6))[2]) or -3
    --next_screen = new_screen_title(score, number)

    -- TODO: start with a title screen
    next_screen = new_screen_level_select()
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

-- TODO: player: invincibility on being shot
-- TODO: player: invincibility VFX

-- TODO: player: shooting
-- TODO: player: shooting SFX
-- TODO: player: shooting interval on a constant or repeated button press
-- TODO: player being hit (lose live?) on collision with an enemy

-- TODO: lives 
-- TODO: live lost SFX

-- TODO: pickups 
-- TODO: pickups retrieval after live lost

-- TODO: enemies: enemy flying on sine path and shooting  
-- TODO: enemies: enemy staying in place then flying fast  
-- TODO: enemies: enemy shooting a lot  

-- TODO: score items with magnet?

-- TODO: enemy being hit VFX 
-- TODO: enemy destroyed VFX

-- TODO: level ends on finish region reached + no more enemies? Or rather: introduce boss and finish after boss?

-- TODO: boss mechanic

-- TODO: screen shake?

-- TODO: "hit stop"?

-- TODO: lighten/darken transition between screens? Or dithered "fillp" one?

-- TODO: "mission"? "level"? "stage"?

-- TODO: menu music
-- TODO: music per stage
-- TODO: music per boss stage

-- TODO: remove unused sprites
-- TODO: remove unused SFXs
-- TODO: remove unused music

-- TODO: consider license other than MIT

-- TODO: for archive purposes: add native build to dist script, and write down in README what PICO-8 version was used to create this game

