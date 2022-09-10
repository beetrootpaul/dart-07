-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/shockwave.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- --

do
    local next_id = 0

    function new_shockwave(center_xy, speed)
        next_id = next_id + 1

        local x = center_xy.x + _gaox
        local y = center_xy.y

        local r_min, r_max, r_step = 11, 88, 7

        local r_progress = new_movement_line_factory {
            -- keep in sync: amount of steps to add to "r_max" here is taken from the smallest circle drawn in "_draw()"
            frames = ceil((r_max + 4 * r_step) / speed),
            angle = 0,
            angled_speed = speed,
        }(_xy(0, 0))

        local function draw_circle(r)
            if r == mid(r_min, r, r_max) then
                oval(
                    x - r,
                    y - r,
                    x + r,
                    y + r,
                    _color_6_light_grey
                )
            end
        end

        local function draw_negative_ring(r_outer, r_inner)
            r_outer = mid(r_inner, r_outer, r_max)
            r_inner = mid(r_min, r_inner, r_outer)
            if r_inner == r_outer then return end

            -- Negative ring implementation below is based on a code snippet from user FReDs72. Thanks a lot!

            -- use screen memory as if it was a sprite sheet (needed for "sspr" and "pal" used below)
            poke(0x5f54, 0x60)
            pal(_palette_negative)

            for dy = -r_outer, r_outer do
                local dx_outer = ceil(sqrt(r_outer * r_outer - dy * dy))
                local dx_inner = ceil(sqrt(r_inner * r_inner - dy * dy))
                local sy = y + dy
                sspr(
                    x - dx_outer, sy,
                    dx_outer - dx_inner, 1,
                    x - dx_outer, sy
                )
                sspr(
                    x + dx_inner, sy,
                    dx_outer - dx_inner, 1,
                    x + dx_inner, sy
                )
            end

            pal()
            -- reset screen memory usage to its normal state
            poke(0x5f54, 0x0)
        end

        return {
            id = next_id,

            has_finished = r_progress.has_finished,

            collision_circle = function()
                return {
                    xy = center_xy,
                    r = r_progress.xy.x,
                }
            end,

            _update = r_progress._update,

            _draw = function()
                local r = flr(r_progress.xy.x)

                draw_negative_ring(r, r - 6)

                draw_circle(r - 2 * r_step)

                local r_stepped = flr(r / r_step) * r_step
                draw_circle(r_stepped - 2 * r_step)
                draw_circle(r_stepped - 3 * r_step)
                -- keep in sync: smallest circle drawn above determines amount of steps to add to "r_max" when calculating "frames" for "r_progress"
            end,
        }
    end

end

