-- -- -- -- -- -- -- --
-- common/timer.lua  --
-- -- -- -- -- -- -- --

-- ttl = amount of frames to count towards 0
function new_timer(ttl)
    local timer = {
        ttl = ttl,
    }

    function timer.advance()
        timer.ttl = timer.ttl - 1
    end

    return timer
end
