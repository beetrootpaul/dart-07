-- -- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/level.lua --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: add level particles like sea waves, stars, floating corrupted matter

-- to avoid thinking in x and y we talk here about
--   - distance = how many tiles we have scrolled forward (can be fraction)
--   - lane     = which row of tiles are we talking about, perpendicular to distance 
function new_level(descriptor)
    local max_defined_distance = descriptor.max_defined_distance
    local structures = descriptor.structures
    local enemies = descriptor.enemies

    -- gui occupies 2 first tiles, which is 16 px
    local offset_y = 16
    -- we draw enemy in center of block of 4 tiles, but store them in the top-left tile's position
    local enemy_offset_x, enemy_offset_y = _ts / 2, _ts / 2

    local min_visible_distance = 1

    return {
        has_reached_end = function()
            return min_visible_distance + _vst >= max_defined_distance
        end,

        update = function()
            min_visible_distance = min_visible_distance + _distance_scroll_per_frame
        end,

        draw = function()
            -- for simplicity let's ignore an edge case of an integer min_visible_distance 
            -- where we see 1 tile less across the screen
            local max_visible_distance = min_visible_distance + _vst
            -- TODO: fix enemies disappearing because their offseted distance goes off the screen
            for distance = flr(min_visible_distance), ceil(max_visible_distance) do
                for lane = 1, 12 do

                    local structures_tile = structures[distance][lane]
                    if structures_tile then
                        local x = flr((distance - min_visible_distance) * _ts)
                        local y = offset_y + (lane - 1) * _ts
                        spr(structures_tile, x, y)
                    end

                    local enemy_tile = enemies[distance] and enemies[distance][lane] or nil
                    if enemy_tile then
                        local x = flr((distance - min_visible_distance) * _ts) + enemy_offset_x
                        local y = offset_y + (lane - 1) * _ts + enemy_offset_y
                        spr(enemy_tile, x, y)
                    end
                    
                end
            end
        end,
    }
end 