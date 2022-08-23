-- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/screen_level.lua  --
-- -- -- -- -- -- -- -- -- -- -- --

function new_screen_level(score, number)
    local score = score
    local number = number

    local player = new_player()

    local current_distance = 1
    local max_distance = -1

    for _ = 1, 100 do
        add(stars, {
            x = flr(rnd(128)),
            y = flr(16 + rnd(128 - 32)),
            speed = 1,
        })
    end

    local tiles = {}
    local enemies = {}

    local bg_tile
    if _lvl_number == 1 then
        bg_tile = 192
    end
    if _lvl_number == 2 then
        bg_tile = 230
    end
    if _lvl_number == 3 then
        bg_tile = 211
    end

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

    local screen = {}

    function screen.score()
        return score
    end
    function screen.number()
        return number
    end

    function screen.init()
        music(10)
    end

    function screen.update()
        local next = screen
        
        current_distance = current_distance + 2 / 8

        player.update()

        if btnp(_button_left) then
            number = number - 1
        end
        if btnp(_button_right) then
            number = number + 1
        end
        if btnp(_button_o) then
            sfx(10)
            score = score + 10
        end
        if btnp(_button_x) or current_distance >= max_distance then
            if _lvl_number < 3 then
                local params = score .. "," .. number
                load("shmup-level-" .. (_lvl_number + 1) .. ".p8", nil, params)
                load("shmup/shmup-level-" .. (_lvl_number + 1) .. ".p8", nil, params)
                load("#tmp_multicart_lvl" .. (_lvl_number + 1), nil, params)
            else
                local params = score .. "," .. number
                load("shmup.p8", nil, params)
                load("shmup/shmup.p8", nil, params)
                load("#tmp_multicart_main", nil, params)
            end
        end

        return next
    end

    function screen.draw()
        cls(_bg_color)

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

        player.draw()

        print("score  : " .. score, 10, 10, _color_blue)
        print("number : " .. number, 10, 16, _color_blue)
    end

    return screen
end
