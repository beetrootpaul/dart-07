-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/shockwave.lua  --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: polish it
-- TODO NEXT: consider going back to negative color ring problem ( https://www.lexaloffle.com/bbs/?tid=46286 )

do
    local next_id = 0

    function new_shockwave(center_xy, speed)
        next_id = next_id + 1

        local r_progress = new_movement_line_factory {
            frames = ceil(_gah / speed) - 20,
            angle = 0,
            angled_speed = speed,
        }(_xy(0, 0))

        local step = 7 -- keep it odd to make further colors work

        local function draw_circle(r)
            if r > 8 then
                oval(
                    center_xy.x + _gaox - r - 1,
                    center_xy.y - r - 1,
                    center_xy.x + _gaox + r,
                    center_xy.y + r,
                    _color_7_white
                )
            end
        end

        return {
            id = next_id,

            has_finished = function()
                return r_progress.has_finished()
            end,

            collision_circle = function()
                return {
                    xy = center_xy,
                    r = r_progress.xy.x,
                }
            end,

            _update = function()
                r_progress._update()
            end,

            _draw = function()
                local r = flr(r_progress.xy.x)
                draw_circle(r)
                r = flr(r / step) * step
                draw_circle(r)
                r = r - step
                draw_circle(r)
            end,
        }
    end

end

