-- -- -- -- -- -- -- -- -- --
-- common/timer/timer.lua  --
-- -- -- -- -- -- -- -- -- --

-- ttl = amount of frames to count towards 0
function new_timer(initial_ttl)
    local timer = {
        ttl = initial_ttl,
    }

    function timer.advance()
        timer.ttl = timer.ttl - 1
    end

    function timer.restart()
        timer.ttl = initial_ttl
    end

    return timer
end
