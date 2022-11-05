-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/explosion.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- --
function new_explosion(start_xy, magnitude, wait_frames, on_started)
    local particles = {}
    for _ = 1, 9 do
        add(particles, {
            angle = .25 + .5 * (rnd() - .5),
            xy = start_xy.plus(magnitude * (rnd() - .5), magnitude * (rnd() - .5)),
            r = magnitude / 2 + rnd(magnitude / 2)
        })
    end
    local wait_timer = new_timer(wait_frames or 0)
    return {
        has_finished = function()
            for particle in all(particles) do
                if particle.r > 0 then
                    return false
                end
            end
            return true
        end,
        _update = function()
            wait_timer._update()
            if wait_timer.ttl <= 0 then
                (on_started or _noop)()
                for particle in all(particles) do
                    if particle.r > 0 then
                        particle.angle = particle.angle + .1 * (rnd() - .5)
                        local speed = rnd()
                        particle.xy = particle.xy.plus(speed * cos(particle.angle), speed * sin(particle.angle))
                        particle.r = max(0, particle.r - magnitude * rnd() / 20)
                    end
                end
            end
        end,
        _draw = function()
            if wait_timer.ttl <= 0 then
                fillp(0xa5a5)
                for particle in all(particles) do
                    local r = particle.r
                    if r > 0 then
                        local c1, c2 = _color_9_dark_orange, _color_8_red
                        if r < magnitude * .2 then
                            c1, c2 = _color_13_lavender, _color_14_mauve
                        elseif r < magnitude * .4 then
                            c1, c2 = _color_6_light_grey, _color_13_lavender
                        elseif r < magnitude * .6 then
                            c1, c2 = _color_6_light_grey, _color_15_peach
                        elseif r < magnitude * .8 then
                            c1, c2 = _color_15_peach, _color_9_dark_orange
                        end
                        circfill(_gaox + particle.xy.x, particle.xy.y, r, 16 * c1 + c2)
                    end
                end
                fillp()
            end
        end
    }
end
