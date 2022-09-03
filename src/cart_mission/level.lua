-- -- -- -- -- -- -- -- -- --
-- cart_mission/level.lua  --
-- -- -- -- -- -- -- -- -- --

-- TODO: add level particles like stars or floating corrupted matter

-- to avoid thinking in x and y we talk here about
--   - distance = how many tiles we have scrolled forward (can be fraction)
--   - lane     = which row of tiles are we talking about, perpendicular to distance 
function new_level(descriptor)
    local max_defined_distance = descriptor.max_defined_distance
    local structures = descriptor.structures
    local enemies = descriptor.enemies

    -- we draw enemy in center of block of 4 tiles, but store them in the top-left tile's position
    local enemy_offset = _xy(_ts / 2, _ts / 2)

    local min_visible_distance = 1
    local max_visible_distance = min_visible_distance + _vst - 1

    local prev_spawn_distance = max_visible_distance
    local spawn_distance_offset = 1
    local spawn_distance = max_visible_distance + spawn_distance_offset

    -- TODO NEXT: externalize animated/static tile to its own file, create it in level descriptor
    local animation_frame = 0
    local animation_steps = 4
    local animation_step_length = 12
    local animated_bg_tiles = { 69, 85, 101, 117 }

    -- phase: intro -> main -> outro 
    local phase = "intro"

    return {
        enter_phase_main = function()
            phase = "main"
        end,

        has_scrolled_to_end = function()
            if phase == "intro" then
                return false
            elseif phase == "main" then
                return min_visible_distance >= max_defined_distance + 1
            elseif phase == "outro" then
                return true
            end
        end,

        enemies_to_spawn = function()
            if phase == "intro" then
                return {}
            elseif phase == "main" then
                local result = {}
                if spawn_distance > prev_spawn_distance then
                    prev_spawn_distance = spawn_distance
                    for lane = 1, 12 do
                        local enemy_map_marker = enemies[spawn_distance] and enemies[spawn_distance][lane] or nil
                        if enemy_map_marker then
                            add(result, {
                                enemy_map_marker = enemy_map_marker,
                                xy = _xy(
                                    _gaox + (lane - .5) * _ts,
                                    _vs - _ts - (spawn_distance - min_visible_distance + .5) * _ts
                                ).plus(enemy_offset),
                            })
                        end
                    end
                end
                return result
            elseif phase == "outro" then
                return {}
            end
        end,

        _update = function()
            animation_frame = (animation_frame + 1) % (animation_steps * animation_step_length)

            if phase ~= "outro" and min_visible_distance >= max_defined_distance + 1 then
                phase = "outro"
            end

            min_visible_distance = min_visible_distance + _m.scroll_per_frame / _ts
            if phase == "intro" then
                -- loop infinitely
                min_visible_distance = min_visible_distance % 1 + 1
            elseif phase == "main" then
                if spawn_distance < flr(max_visible_distance) + spawn_distance_offset then
                    spawn_distance = flr(max_visible_distance) + spawn_distance_offset
                end
            elseif phase == "outro" then
                -- loop infinitely
                local distance_fraction = min_visible_distance - flr(min_visible_distance)
                min_visible_distance = max_defined_distance + distance_fraction
            end
            max_visible_distance = min_visible_distance + _vst - 1
        end,

        _draw = function(opts)
            local draw_within_level_bounds = opts.draw_within_level_bounds

            local bg_tile = _m.has_bg_tiles and animated_bg_tiles[flr(animation_frame / animation_step_length) + 1] or nil

            clip(_gaox, 0, _gaw, _gah)

            for distance = flr(min_visible_distance), ceil(max_visible_distance) do
                for lane = 1, 12 do
                    local x = _gaox + (lane - 1) * _ts
                    local y = _vs - flr((distance - min_visible_distance + 1) * _ts)

                    if bg_tile then
                        spr(bg_tile, x, y)
                    end

                    if phase == "main" then
                        local fg_tile = structures[distance][lane]
                        if fg_tile then
                            spr(fg_tile, x, y)
                        end
                    end
                end
            end

            draw_within_level_bounds()

            clip()
        end,
    }
end 