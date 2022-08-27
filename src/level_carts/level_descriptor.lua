-- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/level_descriptor.lua --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: consider moving level definition from sprite sheet to map, since it would fit (and would occupy the whole available space),
--       and we could use more of the sprite sheet for other things

-- TODO: animated structure tiles (i.e. waves around islands)

function new_level_descriptor()
    -- numbers below are colors in the sprite sheet
    local marker_types = {
        structure = 13,
        enemy_sinusoidal = 12,
        enemy_wait_then_charge = 10,
        level_end = 8,
    }

    -- TODO: draw all tiles for all missions/levels
    local structure_tiles = {
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

    -- markers from all 4 rows of 3rd sprite sheet tab, combined into a single long 2D array
    -- and extended by several extra columns in order to make further computations easier
    local markers = {}
    local sprite_sheet_tab = 2
    for sprite_sheet_tab_row = 0, 3 do
        for sprite_sheet_x = 0, 127 do
            local x = 1 + sprite_sheet_tab_row * 128 + sprite_sheet_x
            markers[x] = {}
            local sprites_sheet_row_y = sprite_sheet_tab * 32 + sprite_sheet_tab_row * 8
            for y = 1, 6 do
                markers[x][y] = sget(sprite_sheet_x, sprites_sheet_row_y + y)
            end
        end
    end
    for buffer_x = 1, _vst + 1 do
        add(markers, { {}, {}, {}, {}, {}, {} })
    end

    -- conversion from markers to level descriptor
    local structures_occupied = { [-1] = {}, [0] = {} }
    local structures = {}
    local enemies = {}
    local max_defined_distance = 0
    for x = 1, #markers do
        local distance = x * 2 - 1
        structures_occupied[distance] = {}
        structures_occupied[distance + 1] = {}
        structures[distance] = {}
        structures[distance + 1] = {}
        enemies[distance] = {}
        enemies[distance + 1] = {}
        for y = 1, 6 do
            local lane = y * 2 - 1

            local marker = markers[x][y]
            if marker == marker_types.level_end then
                max_defined_distance = distance - 1
                break
            elseif marker == marker_types.enemy_sinusoidal then
                enemies[distance][lane] = "sinusoidal"
            elseif marker == marker_types.enemy_wait_then_charge then
                enemies[distance][lane] = "wait_then_charge"
            elseif marker == marker_types.structure then
                structures_occupied[distance][lane] = true
                structures_occupied[distance][lane + 1] = true
                structures_occupied[distance + 1][lane] = true
                structures_occupied[distance + 1][lane + 1] = true

                -- guard tiles to make further computations easier
                if lane == 1 then
                    structures_occupied[distance][-1] = true
                    structures_occupied[distance][0] = true
                    structures_occupied[distance + 1][-1] = true
                    structures_occupied[distance + 1][0] = true
                    --if distance == 1 then
                    --    structures_occupied[-1][-1] = true
                    --    structures_occupied[-1][0] = true
                    --    structures_occupied[0][-1] = true
                    --    structures_occupied[0][0] = true
                    --end
                elseif lane + 1 == 12 then
                    structures_occupied[distance][13] = true
                    structures_occupied[distance][14] = true
                    structures_occupied[distance + 1][13] = true
                    structures_occupied[distance + 1][14] = true
                    --if distance == 1 then
                    --    structures_occupied[-1][13] = true
                    --    structures_occupied[-1][14] = true
                    --    structures_occupied[0][13] = true
                    --    structures_occupied[0][14] = true
                    --end
                end
                if distance == 1 then
                    structures_occupied[-1][lane] = true
                    structures_occupied[-1][lane + 1] = true
                    structures_occupied[0][lane] = true
                    structures_occupied[0][lane + 1] = true
                end
            end
        end
        if max_defined_distance > 0 then
            break
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
            local slt, smt, srt = structures_occupied[distance - 2][lane - 1], structures_occupied[distance - 1][lane - 1], structures_occupied[distance][lane - 1]
            local slm, smm, srm = structures_occupied[distance - 2][lane], structures_occupied[distance - 1][lane], structures_occupied[distance][lane]
            local slb, smb, srb = structures_occupied[distance - 2][lane + 1], structures_occupied[distance - 1][lane + 1], structures_occupied[distance][lane + 1]
            local sllt, sllb = structures_occupied[distance - 3][lane - 1], structures_occupied[distance - 3][lane + 1]
            local srrt, srrb = structures_occupied[distance + 1][lane - 1], structures_occupied[distance + 1][lane + 1]
            local sltt, srtt = structures_occupied[distance - 2][lane - 2], structures_occupied[distance][lane - 2]
            local slbb, srbb = structures_occupied[distance - 2][lane + 2], structures_occupied[distance][lane + 2]
            if smm then
                if not slm and not smt then
                    structures[distance - 1][lane] = structure_tiles.outside_left_top
                elseif not slm and not smb then
                    structures[distance - 1][lane] = structure_tiles.outside_left_bottom
                elseif not srm and not smt then
                    structures[distance - 1][lane] = structure_tiles.outside_right_top
                elseif not srm and not smb then
                    structures[distance - 1][lane] = structure_tiles.outside_right_bottom
                elseif not slm and not slt and not slb then
                    structures[distance - 1][lane] = structure_tiles.edge_left
                elseif not srm and not srt and not srb then
                    structures[distance - 1][lane] = structure_tiles.edge_right
                elseif not smt and not slt and not srt then
                    structures[distance - 1][lane] = structure_tiles.edge_top
                elseif not smb and not slb and not srb then
                    structures[distance - 1][lane] = structure_tiles.edge_bottom
                elseif (not sllt and slm and not smt and srt) or (not sltt and smt and not slm and slb) then
                    structures[distance - 1][lane] = structure_tiles.filler_left_top
                elseif (not sllb and slm and not smb and srb) or (not slbb and smb and not slm and slt) then
                    structures[distance - 1][lane] = structure_tiles.filler_left_bottom
                elseif (not srrt and srm and not smt and slt) or (not srtt and smt and not srm and srb) then
                    structures[distance - 1][lane] = structure_tiles.filler_right_top
                elseif (not srrb and srm and not smb and slb) or (not srbb and smb and not srm and srt) then
                    structures[distance - 1][lane] = structure_tiles.filler_right_bottom
                else
                    structures[distance - 1][lane] = structure_tiles.center
                end
            else
                if slm and smt then
                    structures[distance - 1][lane] = structure_tiles.inner_left_top
                elseif slm and smb then
                    structures[distance - 1][lane] = structure_tiles.inner_left_bottom
                elseif srm and smt then
                    structures[distance - 1][lane] = structure_tiles.inner_right_top
                elseif srm and smb then
                    structures[distance - 1][lane] = structure_tiles.inner_right_bottom
                end
            end
        end
    end

    return {
        structures = structures,
        enemies = enemies,
        max_defined_distance = max_defined_distance,
    }
end 