-- -- -- -- -- -- --
-- poc/level.lua  --
-- -- -- -- -- -- --

function new_level()
    local stars = {}

    for _ = 1, 100 do
        add(stars, {
            x = flr(rnd(128)),
            y = flr(rnd(128)),
        })
    end

    local tiles = {}
    local enemies = {}

    -- TODO: 2nd row from the sprite sheet
    for sx = 0, 127 do
        local distance = sx + 1
        tiles[distance] = {}
        enemies[distance] = {}
        for sy = 64, 71 do
            local position = sy - 63
            local c = sget(sx, sy)
            if c == _color_lavender then
                -- TODO: corner tiles
                tiles[distance][position] = 160
            end
            if c == _color_dark_purple then
                enemies[distance][position] = 3
            end
            if c == _color_blue then
                enemies[distance][position] = 19
            end
            if c == _color_green then
                enemies[distance][position] = 35
            end
            if c == _color_white then
                enemies[distance][position] = 51
            end
        end
    end

    return {
        draw = function()
            for star in all(stars) do
                pset(star.x, star.y, _color_light_grey)
            end
            rectfill(0, 0, 127, 31, _color_dark_grey)
            rectfill(0, 95, 127, 127, _color_dark_grey)
            for distance = 1, 16 do
                for position = 1, 8 do
                    local t = tiles[distance][position]
                    if t then
                        spr(t, distance * 8 - 8, 32 + position * 8 - 8)
                    end
                    local e = enemies[distance][position]
                    if e then
                        spr(e, distance * 8 - 8, 32 + position * 8 - 8)
                    end
                end
            end
        end,
    }
end