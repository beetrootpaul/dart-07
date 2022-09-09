-- -- -- -- -- -- -- --
-- common/fade.lua   --
-- -- -- -- -- -- -- --

-- direction: "in" | "out"
function new_fade(direction, fade_frames, wait_frames)
    -- from fully transparent to fully black
    local patterns = split(
        "0xffff.8,0xffdf.8,0x7fdf.8,0x5f5f.8,0x5b5e.8,0x5a5a.8,0x5852.8,0x5050.8,0x1040.8,0x0040.8,0x0000.8"
    )
    local strip_hs = split(
        _vs .. ",4,4,4,4,4,4,4,4,4," .. _vs
    )

    local y_min = 0
    for i = 1, #strip_hs - 1 do
        y_min = y_min - strip_hs[i]
    end

    local fade_movement = new_movement_sequence_factory {
        new_movement_fixed_factory {
            frames = wait_frames or 0,
        },
        new_movement_to_target_factory {
            frames = fade_frames,
            target_y = 0,
        },
    }(_xy(0, y_min))

    return {
        has_finished = function()
            return fade_movement.has_finished()
        end,

        _update = function()
            fade_movement._update()
        end,

        _draw = function()
            local i, y, strip_h = 1, fade_movement.xy.y, 0
            while i <= #patterns do
                y = y + strip_h
                strip_h = strip_hs[i]

                fillp(patterns[direction == "in" and i or (#patterns - i + 1)])
                rectfill(
                    0, y,
                    _vs - 1, y + strip_h - 1,
                    _color_0_black
                )
                fillp()

                i = i + 1
            end
        end,

    }
end
