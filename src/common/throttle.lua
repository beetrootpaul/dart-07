-- -- -- -- -- -- -- -- --
-- common/throttle.lua  --
-- -- -- -- -- -- -- -- --
function new_throttle(throttled_fn)
    local frames_since_last_passed_invoke = 9999
    return {
        _update = function()
            frames_since_last_passed_invoke = min(frames_since_last_passed_invoke + 1, 9999)
        end,
        invoke_if_ready = function(throttle_length_in_frames, throttled_fn_params_factory)
            if frames_since_last_passed_invoke >= throttle_length_in_frames then
                frames_since_last_passed_invoke = 0
                throttled_fn(throttled_fn_params_factory())
            end
        end
    }
end
