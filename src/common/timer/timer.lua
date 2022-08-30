-- -- -- -- -- -- -- -- -- --
-- common/timer/timer.lua  --
-- -- -- -- -- -- -- -- -- --

function new_timer(frames)
    local timer = {
        ttl = frames,
    }

    function timer.advance()
        timer.ttl = max(timer.ttl - 1, 0)
    end

    function timer.passed_ratio()
        return 1 - timer.ttl / (frames - 1)
    end

    function timer.restart()
        timer.ttl = frames
    end

    return timer
end
