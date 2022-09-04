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
        -- TODO: rethink this timer since it looks like bad things are happening here…
        if frames <= 1 then
            return 1
        end
        return mid(0, 1 - timer.ttl / (frames - 1), 1)
    end

    function timer.restart()
        timer.ttl = frames
    end

    return timer
end
