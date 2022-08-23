-- -- -- -- -- -- --
-- poc/level.lua  --
-- -- -- -- -- -- --

function new_level(level_number)
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

    local max_distance = -1

    local bg_tile
    if level_number == 1 then
        bg_tile = 192
    end
    if level_number == 2 then
        bg_tile = 230
    end
    if level_number == 3 then
        bg_tile = 211
    end
    printh(bg_tile)

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
                tiles[distance][lane] = bg_tile
                tiles[distance][lane + 1] = bg_tile
                tiles[distance + 1][lane] = bg_tile
                tiles[distance + 1][lane + 1] = bg_tile
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
            if max_distance < 0 and c == _color_red then
                max_distance = distance
            end
            lane = lane + 2
        end
        distance = distance + 2
    end
    for sx = 0, 127 do
        tiles[distance] = {}
        tiles[distance + 1] = {}
        enemies[distance] = {}
        enemies[distance + 1] = {}

        local lane = 1
        for sy = 73, 78 do
            local c = sget(sx, sy)
            if c == _color_lavender then
                -- TODO: corner tiles
                tiles[distance][lane] = bg_tile
                tiles[distance][lane + 1] = bg_tile
                tiles[distance + 1][lane] = bg_tile
                tiles[distance + 1][lane + 1] = bg_tile
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
            if max_distance < 0 and c == _color_red then
                max_distance = distance
            end
            lane = lane + 2
        end
        distance = distance + 2
    end

    return {
        update = function()
            current_distance = current_distance + 2 / 8
        end,
        has_finished = function()
            return current_distance >= max_distance
        end,
        draw = function()
            if level_number == 1 then
                cls(_color_dark_blue)
            end
            if level_number == 2 then
                cls(_color_dark_purple)
            end
            if level_number == 3 then
                cls(_color_dark_grey)
            end

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