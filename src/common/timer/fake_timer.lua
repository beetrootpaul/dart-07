-- -- -- -- -- -- -- -- -- -- -- --
-- common/timer/fake_timer.lua   --
-- -- -- -- -- -- -- -- -- -- -- --

function new_fake_timer()
    return {
        ttl = 1, -- keep it always above 0, so this "timer" never finishes
        advance = function()
        end,
        passed_ratio = function()
            return 0
        end,
        restart = function()
        end,
    }
end
