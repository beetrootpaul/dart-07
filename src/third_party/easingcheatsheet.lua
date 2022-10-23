-- Easing functions copied from #easingcheatsheet cart on BBS
-- See: https://www.lexaloffle.com/bbs/?tid=40577
--
-- Modified by Beetroot Paul to match build flow and style of this codebase.
-- Also, commented out functions unused in this codebase, so the token usage is lower.
--
function _easing_linear(t)
    return t
end

function _easing_easeinquad(t)
    return t * t
end

function _easing_easeoutquad(t)
    -- original implementation:
    --t = t - 1
    --return 1 - t * t
    -- implementation optimised for tokens: 
    return 1 - (t - 1) ^ 2
end

--function _easing_easeinoutquad(t)
--    if (t < .5) then
--        return t * t * 2
--    else
--        t = t - 1
--        return 1 - t * t * 2
--    end
--end
--function _easing_easeoutinquad(t)
--    if t < .5 then
--        t = t - .5
--        return .5 - t * t * 2
--    else
--        t = t - .5
--        return .5 + t * t * 2
--    end
--end
function _easing_easeinquart(t)
    -- original implementation:
    --return t * t * t * t
    -- implementation optimised for tokens: 
    return t ^ 4
end

function _easing_easeoutquart(t)
    -- original implementation:
    --t = t - 1
    --return 1 - t * t * t * t
    -- implementation optimised for tokens: 
    return 1 - (t - 1) ^ 4
end

--function _easing_easeinoutquart(t)
--    if t < .5 then
--        return 8 * t * t * t * t
--    else
--        t = t - 1
--        return (1 - 8 * t * t * t * t)
--    end
--end
--function _easing_easeoutinquart(t)
--    if t < .5 then
--        t = t - .5
--        return .5 - 8 * t * t * t * t
--    else
--        t = t - .5
--        return .5 + 8 * t * t * t * t
--    end
--end
--function _easing_easeinovershoot(t)
--    return 2.7 * t * t * t - 1.7 * t * t
--end
--function _easing_easeoutovershoot(t)
--    t = t - 1
--    return 1 + 2.7 * t * t * t + 1.7 * t * t
--end
--function _easing_easeinoutovershoot(t)
--    if t < .5 then
--        return (2.7 * 8 * t * t * t - 1.7 * 4 * t * t) / 2
--    else
--        t = t - 1
--        return 1 + (2.7 * 8 * t * t * t + 1.7 * 4 * t * t) / 2
--    end
--end
--function _easing_easeoutinovershoot(t)
--    if t < .5 then
--        t = t - .5
--        return (2.7 * 8 * t * t * t + 1.7 * 4 * t * t) / 2 + .5
--    else
--        t = t - .5
--        return (2.7 * 8 * t * t * t - 1.7 * 4 * t * t) / 2 + .5
--    end
--end
--function _easing_easeinelastic(t)
--    if (t == 0) then return 0 end
--    return 2 ^ (10 * t - 10) * cos(2 * t - 2)
--end
--function _easing_easeoutelastic(t)
--    if (t == 1) then return 1 end
--    return 1 - 2 ^ (-10 * t) * cos(2 * t)
--end
--function _easing_easeinoutelastic(t)
--    if t < .5 then
--        return 2 ^ (10 * 2 * t - 10) * cos(2 * 2 * t - 2) / 2
--    else
--        t = t - .5
--        return 1 - 2 ^ (-10 * 2 * t) * cos(2 * 2 * t) / 2
--    end
--end
--function _easing_easeoutinelastic(t)
--    if t < .5 then
--        return .5 - 2 ^ (-10 * 2 * t) * cos(2 * 2 * t) / 2
--    else
--        t = t - .5
--        return 2 ^ (10 * 2 * t - 10) * cos(2 * 2 * t - 2) / 2 + .5
--    end
--end
--function _easing_easeinbounce(t)
--    t = 1 - t
--    local n1 = 7.5625
--    local d1 = 2.75
--
--    if (t < 1 / d1) then
--        return 1 - n1 * t * t;
--    elseif (t < 2 / d1) then
--        t = t - 1.5 / d1
--        return 1 - n1 * t * t - .75;
--    elseif (t < 2.5 / d1) then
--        t = t - 2.25 / d1
--        return 1 - n1 * t * t - .9375;
--    else
--        t = t - 2.625 / d1
--        return 1 - n1 * t * t - .984375;
--    end
--end
--function _easing_easeoutbounce(t)
--    local n1 = 7.5625
--    local d1 = 2.75
--
--    if (t < 1 / d1) then
--        return n1 * t * t;
--    elseif (t < 2 / d1) then
--        t = t - 1.5 / d1
--        return n1 * t * t + .75;
--    elseif (t < 2.5 / d1) then
--        t = t - 2.25 / d1
--        return n1 * t * t + .9375;
--    else
--        t = t - 2.625 / d1
--        return n1 * t * t + .984375;
--    end
--end
--other useful functions:
--(linear interpolation between a/b)
function _easing_lerp(a, b, t)
    return a + (b - a) * t
end

--(finds the t value that would
--return v in a lerp between a/b)
function _easing_invlerp(a, b, v)
    return (v - a) / (b - a)
end
