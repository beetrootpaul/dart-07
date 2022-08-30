-- -- -- -- -- -- -- -- -- --
-- cart_mission/level.lua  --
-- -- -- -- -- -- -- -- -- --

-- TODO: add level particles like sea waves, stars, floating corrupted matter
-- TODO: animated tiles (waves near shores)

-- to avoid thinking in x and y we talk here about
--   - distance = how many tiles we have scrolled forward (can be fraction)
--   - lane     = which row of tiles are we talking about, perpendicular to distance 
function new_level(descriptor)
    local max_defined_distance = descriptor.max_defined_distance
    local structures = descriptor.structures
    local enemies = descriptor.enemies

    -- we draw enemy in center of block of 4 tiles, but store them in the top-left tile's position
    local enemy_offset_x, enemy_offset_y = _ts / 2, _ts / 2

    local min_visible_distance = 1
    local max_visible_distance = min_visible_distance + _vst - 1

    return {
        has_reached_end = function()
            return min_visible_distance + _vst >= max_defined_distance
        end,

        enemies_to_spawn = function()
            local result = {}
            local spawn_distance = max_visible_distance == ceil(max_visible_distance) and max_visible_distance + 1 or nil
            if spawn_distance then
                for lane = 1, 12 do
                    local enemy_type = enemies[spawn_distance] and enemies[spawn_distance][lane] or nil
                    if enemy_type then
                        local x = (spawn_distance - min_visible_distance + .5) * _ts + enemy_offset_x
                        local y = _gaoy + (lane - .5) * _ts + enemy_offset_y
                        add(result, {
                            enemy_type = enemy_type,
                            x = x,
                            y = y,
                        })
                    end
                end
            end
            return result
        end,

        scroll = function()
            min_visible_distance = min_visible_distance + _scroll_per_frame / _ts
            max_visible_distance = min_visible_distance + _vst - 1
        end,

        draw = function()
            for distance = flr(min_visible_distance), ceil(max_visible_distance) do
                for lane = 1, 12 do
                    local structures_tile = structures[distance][lane]
                    if structures_tile then
                        local x = flr((distance - min_visible_distance) * _ts)
                        local y = _gaoy + (lane - 1) * _ts
                        spr(structures_tile, x, y)
                    end
                end
            end
        end,
    }
end 