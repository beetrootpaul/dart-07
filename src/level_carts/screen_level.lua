-- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/screen_level.lua  --
-- -- -- -- -- -- -- -- -- -- -- --

-- TODO: ?
--function new_screen_level(score, number)
function new_screen_level()
    -- TODO: ?
    --local score = score
    --local number = number

    local player = new_player()

    -- TODO: encapsulate and rework level deserialization
    local current_distance = 1
    local max_distance = -1

    -- TODO: ?
    --for _ = 1, 100 do
    --    add(stars, {
    --        x = flr(rnd(128)),
    --        y = flr(16 + rnd(128 - 32)),
    --        speed = 1,
    --    })
    --end

    -- TODO: encapsulate and rework level deserialization
    local tiles = {}
    local enemies = {}

    -- TODO: encapsulate and rework level deserialization
    local c_bg_tile = 13
    local c_end = 8
    local c_enemy_1 = 2
    local c_enemy_2 = 11
    local c_enemy_3 = 12
    local c_enemy_4 = 7
    
    -- TODO: encapsulate and rework level deserialization
    local bg_tiles = {
        center = 209,
        edge_left = 208,
        edge_right = 210,
        edge_top = 193,
        edge_bottom = 225,
        outside_left_top = 192,
        outside_left_bottom = 224,
        outside_right_top = 194,
        outside_right_bottom = 226,
        inner_left_top = 211,
        inner_left_bottom = 227,
        inner_right_top = 212,
        inner_right_bottom = 228,
        filler_left_top = 244,
        filler_left_bottom = 196,
        filler_right_top = 243,
        filler_right_bottom = 195,
    }

    -- TODO: encapsulate and rework level deserialization
    local distance = 1
    for level_descriptor_row = 0, 3 do
        for sx = 0, 127 do
            tiles[distance] = {}
            tiles[distance + 1] = {}
            enemies[distance] = {}
            enemies[distance + 1] = {}

            local lane = 1
            for sy = 65 + level_descriptor_row * 8, 70 + level_descriptor_row * 8 do
                local c = sget(sx, sy)
                if c == c_bg_tile then
                    tiles[distance][lane] = bg_tiles.center
                    tiles[distance][lane + 1] = bg_tiles.center
                    tiles[distance + 1][lane] = bg_tiles.center
                    tiles[distance + 1][lane + 1] = bg_tiles.center
                end
                if c == c_enemy_1 then
                    enemies[distance][lane] = 3
                end
                if c == c_enemy_2 then
                    enemies[distance][lane] = 35
                end
                if c == c_enemy_3 then
                    enemies[distance][lane] = 19
                end
                if c == c_enemy_4 then
                    enemies[distance][lane] = 51
                end
                if max_distance < 0 and c == c_end then
                    max_distance = distance
                end
                lane = lane + 2
            end
            distance = distance + 2
        end
    end
    for offset_x = 1, 17 do
        tiles[max_distance + offset_x] = {}
        enemies[max_distance + offset_x] = {}
    end

    local screen = {}

    -- TODO: ?
    --function screen.score()
    --    return score
    --end
    --function screen.number()
    --    return number
    --end

    function screen.init()
        -- TODO: ?
        --music(10)
    end

    function screen.update()
        local next = screen

        current_distance = current_distance + _scrolling_speed

        player.update()

        -- TODO: ?
        --if btnp(_button_left) then
        --    number = number - 1
        --end
        --if btnp(_button_right) then
        --    number = number + 1
        --end
        --if btnp(_button_o) then
        --sfx(10)
        --score = score + 10
        --end

        -- TODO: finish level on conditions different than a button press
        if btnp(_button_x) or current_distance >= max_distance then
            -- TODO: externalize knowledge about amount of available levels
            if _lvl_number < 3 then
                _load_level_cart(_lvl_number + 1)
            else
                _load_main_cart()
            end
        end

        return next
    end

    function screen.draw()
        cls(_bg_color)

        -- TODO: ?
        --for star in all(stars) do
        --    star.x = star.x - star.speed
        --    if star.x < 0 then
        --        star.x = star.x + 128
        --    end
        --    pset(star.x, star.y, _color_light_grey)
        --end

        -- TODO: encapsulate GUI code, make it look good
        rectfill(0, 0, 127, 15, _color_0_black)
        rectfill(0, 112, 127, 127, _color_0_black)

        -- TODO: encapsulate and rework level drawing
        for distance = flr(current_distance), flr(current_distance + 17) do
            for lane = 1, 12 do
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

        -- TODO: ?
        --print("score  : " .. score, 10, 10, _color_12_true_blue)
        --print("number : " .. number, 10, 16, _color_12_true_blue)
    end

    return screen
end
