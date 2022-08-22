-- -- -- -- -- -- --
-- poc/level.lua  --
-- -- -- -- -- -- --

function new_level()
    local stars = {}

    local current_distance = 1

    for _ = 1, 100 do
        add(stars, {
            x = flr(rnd(128)),
            y = flr(16 + rnd(128 - 32)),
            speed = 1,
        })
    end

    local tiles = {}
    local enemies = {}

    -- TODO: 2nd row from the sprite sheet
    local distance = 1
    for sx = 0, 127 do
        tiles[distance] = {}
        tiles[distance + 1] = {}
        enemies[distance] = {}
        enemies[distance + 1] = {}

        local lane = 1
        for sy = 65, 70 do
            local c = sget(sx, sy)
            if c == _color_lavender then
                -- TODO: corner tiles
                tiles[distance][lane] = 160
                tiles[distance][lane + 1] = 160
                tiles[distance + 1][lane] = 160
                tiles[distance + 1][lane + 1] = 160
            end
            if c == _color_dark_purple then
                enemies[distance][lane] = 3
            end
            if c == _color_blue then
                enemies[distance][lane] = 19
            end
            if c == _color_green then
                enemies[distance][lane] = 35
            end
            if c == _color_white then
                enemies[distance][lane] = 51
            end
            lane = lane + 2
        end
        distance = distance + 2
    end

    return {
        update = function()
            current_distance = current_distance + 2 / 8
        end,
        draw = function()
            for star in all(stars) do
                star.x = star.x - star.speed
                if star.x < 0 then
                    star.x = star.x + 128
                end
                pset(star.x, star.y, _color_light_grey)
            end
            rectfill(0, 0, 127, 15, _color_dark_grey)
            rectfill(0, 111, 127, 127, _color_dark_grey)
            for distance = flr(current_distance), flr(current_distance + 17) do
                for lane = 1, 16 do
                    local t = tiles[distance][lane]
                    if t then
                        spr(t, flr((distance - current_distance) * 8 - 8), lane * 8 + 8)
                    end
                    local e = enemies[distance][lane]
                    if e then
                        spr(e, flr((distance - current_distance) * 8 - 4), lane * 8 + 12)
                    end
                end
            end
        end,
    }
end