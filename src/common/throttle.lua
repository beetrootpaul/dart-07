-- -- -- -- -- -- -- -- --
-- common/throttle.lua  --
-- -- -- -- -- -- -- -- --

function new_throttle(throttle_length_in_frames, throttled_function)
    local frames_since_last_passed_invoke = throttle_length_in_frames

    return {
        _update = function()
            -- min applied here guards us against reaching a numerical limit
            frames_since_last_passed_invoke = min(frames_since_last_passed_invoke + 1, throttle_length_in_frames)
        end,
        invoke = function()
            if frames_since_last_passed_invoke >= throttle_length_in_frames then
                frames_since_last_passed_invoke = 0
                throttled_function()
            end
        end,
    }
end
