-- -- -- -- -- -- -- -- -- -- -- --
-- common/timer/fake_timer.lua   --
-- -- -- -- -- -- -- -- -- -- -- --
function new_fake_timer(constant_ttl)
    return {
        ttl = constant_ttl or 1,
        _update = _noop,
        passed_fraction = function()
            return 0
        end,
        restart = _noop
    }
    -- by default, keep it always above 0, so this "timer" never finishes
end
