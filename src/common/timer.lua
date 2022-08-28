-- -- -- -- -- -- -- --
-- common/timer.lua  --
-- -- -- -- -- -- -- --

function new_timer(ttl)
    local timer = {
        ttl = ttl,
    }

    function timer.advance()
        timer.ttl = timer.ttl - 1
    end

    return timer
end
