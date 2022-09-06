-- -- -- -- -- -- -- -- -- -- --
-- cart_mission/explosion.lua --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: polish it

function new_explosion(start_xy, magnitude, wait_frames)
    local particles = {}
    for _ = 1, 9 do
        add(particles, {
            angle = .25 + .5 * (rnd() - .5),
            xy = start_xy.plus(
                magnitude * (rnd() - .5),
                magnitude * (rnd() - .5)
            ),
            r = magnitude / 2 + rnd(magnitude / 2),
        })
    end

    local wait_timer = new_timer(wait_frames or 0)

    return {
        has_finished = function()
            for _, particle in pairs(particles) do
                if particle.r > 0 then
                    return false
                end
            end
            return true
        end,

        _update = function()
            wait_timer._update()
            if wait_timer.ttl <= 0 then
                for _, particle in pairs(particles) do
                    if particle.r > 0 then
                        particle.angle = particle.angle + .1 * (rnd() - .5)
                        local speed = rnd()
                        particle.xy = particle.xy.plus(
                            speed * cos(particle.angle),
                            speed * sin(particle.angle)
                        )
                        particle.r = max(0, particle.r - magnitude * rnd() / 20)
                    end
                end
            end
        end,

        _draw = function()
            if wait_timer.ttl <= 0 then
                fillp(0xa5a5)
                for _, particle in pairs(particles) do
                    if particle.r > 0 then
                        local color = 16 * _color_9_dark_orange + _color_8_red
                        if particle.r < magnitude * .2 then
                            color = 16 * _color_14_lavender + _color_13_mauve
                        elseif particle.r < magnitude * .4 then
                            color = 16 * _color_6_light_grey + _color_14_lavender
                        elseif particle.r < magnitude * .6 then
                            color = 16 * _color_6_light_grey + _color_15_peach
                        elseif particle.r < magnitude * .8 then
                            color = 16 * _color_15_peach + _color_9_dark_orange
                        end
                        circfill(
                            _gaox + particle.xy.x,
                            particle.xy.y,
                            particle.r,
                            color
                        )
                    end
                end
                fillp()
            end
        end,
    }
end

