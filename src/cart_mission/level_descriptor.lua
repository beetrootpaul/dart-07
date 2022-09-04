-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/level_descriptor.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: polished waves on level 1
-- TODO: polished islands on level 1
-- TODO: fg and bg for level 2
-- TODO: fg and bg for level 3

function new_level_descriptor()
    -- number below are sprites in the sprite sheet
    -- * end of the level
    local end_tile = 112
    -- * structure tiles
    local st_center = 81
    local st_edge_left = 80
    local st_edge_right = 82
    local st_edge_top = 65
    local st_edge_bottom = 97
    local st_outside_left_top = 64
    local st_outside_left_bottom = 96
    local st_outside_right_top = 66
    local st_outside_right_bottom = 98
    local st_inner_left_top = 83
    local st_inner_left_bottom = 99
    local st_inner_right_top = 84
    local st_inner_right_bottom = 100
    local st_filler_left_top = 116
    local st_filler_left_bottom = 68
    local st_filler_right_top = 115
    local st_filler_right_bottom = 67

    -- TODO NEXT: handle structure markers in places where enemies are instead or make two types of same enemy marker: w/ and w/o structure behind

    local max_defined_distance

    -- markers from the map, combined into a single long 2D array and extended by several 
    -- extra columns on both sides in -- order to make further computations easier
    local markers = {}
    do
        local markers_per_screen_w = 8
        local x = 1
        for intro_infinite_scroll_x = 1, markers_per_screen_w + 1 do
            markers[x] = { nil, nil, nil, nil, nil, nil }
            x = x + 1
        end
        for level_descriptor_row = 0, 3 do
            for map_x = 0, 127 do
                markers[x] = { nil, nil, nil, nil, nil, nil }
                local map_y = level_descriptor_row * 8
                for y = 1, 6 do
                    local marker = mget(map_x, map_y + y)
                    markers[x][y] = marker
                    if marker == end_tile then
                        max_defined_distance = (x - 1) * 2
                        break
                    end
                end
                x = x + 1
                if max_defined_distance then
                    break
                end
            end
            if max_defined_distance then
                break
            end
        end
        for outro_infinite_scroll_x = 1, markers_per_screen_w + 1 do
            markers[x] = { nil, nil, nil, nil, nil, nil }
            x = x + 1
        end
    end

    -- conversion from markers to level descriptor
    local structures_occupied = { [-1] = {}, [0] = {} }
    local structures = {}
    local enemies = {}
    for x = 1, #markers do
        local distance = x * 2 - 1
        local distance2 = distance + 1
        structures_occupied[distance] = {}
        structures_occupied[distance2] = {}
        structures[distance] = {}
        structures[distance2] = {}
        enemies[distance] = {}
        enemies[distance2] = {}
        for y = 1, 6 do
            local lane = y * 2 - 1
            local lane2 = lane + 1

            local marker = markers[x][y]
            if marker == st_center then
                structures_occupied[distance][lane] = true
                structures_occupied[distance][lane2] = true
                structures_occupied[distance2][lane] = true
                structures_occupied[distance2][lane2] = true

                -- guard tiles to make further computations easier
                if lane == 1 then
                    structures_occupied[distance][-1] = true
                    structures_occupied[distance][0] = true
                    structures_occupied[distance2][-1] = true
                    structures_occupied[distance2][0] = true
                elseif lane2 == 12 then
                    structures_occupied[distance][13] = true
                    structures_occupied[distance][14] = true
                    structures_occupied[distance2][13] = true
                    structures_occupied[distance2][14] = true
                end
                if distance == 1 then
                    structures_occupied[-1][lane] = true
                    structures_occupied[-1][lane2] = true
                    structures_occupied[0][lane] = true
                    structures_occupied[0][lane2] = true
                end
            elseif marker ~= 0 and marker ~= end_tile then
                enemies[distance][lane] = marker
            end
        end
    end

    -- conversion from occupied or not occupied structure tiles to specific structure tile variants 
    for distance = 2, #structures_occupied - 1 do
        for lane = 1, 12 do
            -- we are comparing here tiles around the middle chosen one:
            --  - l = left
            --  - r = right
            --  - t = top
            --  - b = bottom
            --  - m = middle
            local slt, smt, srt = structures_occupied[distance][lane - 1], structures_occupied[distance][lane], structures_occupied[distance][lane + 1]
            local slm, smm, srm = structures_occupied[distance - 1][lane - 1], structures_occupied[distance - 1][lane], structures_occupied[distance - 1][lane + 1]
            local slb, smb, srb = structures_occupied[distance - 2][lane - 1], structures_occupied[distance - 2][lane], structures_occupied[distance - 2][lane + 1]
            local sllt, sllb = structures_occupied[distance][lane - 2], structures_occupied[distance - 2][lane - 2]
            local srrt, srrb = structures_occupied[distance][lane + 2], structures_occupied[distance - 2][lane + 2]
            local sltt, srtt = structures_occupied[distance + 1][lane - 1], structures_occupied[distance + 1][lane + 1]
            local slbb, srbb = structures_occupied[distance - 3][lane - 1], structures_occupied[distance - 3][lane + 1]
            local tile_to_set
            if smm then
                if not slm and not smt then
                    tile_to_set = st_outside_left_top
                elseif not slm and not smb then
                    tile_to_set = st_outside_left_bottom
                elseif not srm and not smt then
                    tile_to_set = st_outside_right_top
                elseif not srm and not smb then
                    tile_to_set = st_outside_right_bottom
                elseif not slm and not slt and not slb then
                    tile_to_set = st_edge_left
                elseif not srm and not srt and not srb then
                    tile_to_set = st_edge_right
                elseif not smt and not slt and not srt then
                    tile_to_set = st_edge_top
                elseif not smb and not slb and not srb then
                    tile_to_set = st_edge_bottom
                elseif (not sllt and slm and not smt and srt) or (not sltt and smt and not slm and slb) then
                    tile_to_set = st_filler_left_top
                elseif (not sllb and slm and not smb and srb) or (not slbb and smb and not slm and slt) then
                    tile_to_set = st_filler_left_bottom
                elseif (not srrt and srm and not smt and slt) or (not srtt and smt and not srm and srb) then
                    tile_to_set = st_filler_right_top
                elseif (not srrb and srm and not smb and slb) or (not srbb and smb and not srm and srt) then
                    tile_to_set = st_filler_right_bottom
                else
                    tile_to_set = st_center
                end
            else
                if slm and smt then
                    tile_to_set = st_inner_left_top
                elseif slm and smb then
                    tile_to_set = st_inner_left_bottom
                elseif srm and smt then
                    tile_to_set = st_inner_right_top
                elseif srm and smb then
                    tile_to_set = st_inner_right_bottom
                end
            end
            structures[distance - 1][lane] = tile_to_set
        end
    end

    return {
        structures = structures,
        enemies = enemies,
        max_defined_distance = max_defined_distance,
    }
end 