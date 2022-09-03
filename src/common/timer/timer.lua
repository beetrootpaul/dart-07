-- -- -- -- -- -- -- -- -- --
-- common/timer/timer.lua  --
-- -- -- -- -- -- -- -- -- --

function new_timer(frames)
    local timer = {
        ttl = frames,
    }

    function timer._update()
        timer.ttl = max(timer.ttl - 1, 0)
    end

    function timer.passed_fraction()
        return 1 - timer.ttl / (frames - 1)
    end

    function timer.restart()
        timer.ttl = frames
    end

    return timer
end
