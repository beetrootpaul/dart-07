-- -- -- -- -- -- -- -- -- --
-- common/timer/timer.lua  --
-- -- -- -- -- -- -- -- -- --
function new_timer(frames, on_finished)
    local timer = {ttl = frames}
    function timer._update()
        timer.ttl = max(timer.ttl - 1, 0)
        if on_finished and timer.ttl <= 0 then
            on_finished()
            on_finished = nil
        end
    end
    
    function timer.passed_fraction()
        -- we refer to "frames - 1" here, because we want "passed_fraction()" to still return "1" _after_ the first "_update()" call
        -- (we usually call "passed_fraction()" in "_draw()" which happens after "_update()")
        return frames <= 1 and 1 or mid(0, 1 - timer.ttl / (frames - 1), 1)
    end
    
    function timer.restart()
        timer.ttl = frames
    end
    
    return timer
end
