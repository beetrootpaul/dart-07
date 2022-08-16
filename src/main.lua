-- -- -- -- --
-- main.lua --
-- -- -- -- --

local pecs_world = pecs()
local c_sprite = pecs_world.component {
    s = 0, -- sprite number on the sprite sheet
}
local s_draw_sprites = pecs_world.system({ c_sprite }, function(e)
    spr(e[c_sprite].s, 20, 30)
end)

function _init()
    pecs_world.entity({},
            c_sprite { s = 1 }
    )
end

function _update60()
    pecs_world.update()
end

function _draw()
    cls(_color_dark_grey)
    s_draw_sprites()
end
