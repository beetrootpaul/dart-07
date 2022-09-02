-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/boss_info.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: better boss info GUI

function new_boss_info(params)
    local slide_in_frames = params.slide_in_frames
    local present_frames = params.present_frames
    local slide_out_frames = params.slide_out_frames

    local slide_in_movement = new_movement_to_target {
        start_x = _gaox,
        start_y = -1,
        target_x = _gaox,
        target_y = _gah / 2,
        frames = slide_in_frames,
        easing_fn = _easing_easeoutquart,
    }
    local present_movement = new_movement_fixed {
        start_x = _gaox,
        start_y = _gah / 2,
        frames = present_frames,
    }
    local slide_out_movement = new_movement_to_target {
        start_x = _gaox,
        start_y = _gah / 2,
        target_x = _gaox,
        target_y = _gah + 1,
        frames = slide_out_frames,
        easing_fn = _easing_easeoutquart,
    }

    -- phase: slide_in -> present -> slide_out
    local phase = "slide_in"

    return {
        _update = function()
            if phase == "slide_in" then
                if slide_in_movement.has_reached_target() then
                    phase = "present"
                    present_movement._update()
                else
                    slide_in_movement._update()
                end
            elseif phase == "present" then
                if present_movement.has_reached_target() then
                    phase = "slide_out"
                    slide_out_movement._update()
                else
                    present_movement._update()
                end
            elseif phase == "slide_out" then
                if slide_out_movement.has_reached_target() then
                else
                    slide_out_movement._update()
                end
            end
        end,

        _draw = function()
            clip(_gaox, 0, _gaw, _gah)

            local x, y
            if phase == "slide_in" then
                x = ceil(slide_in_movement.x)
                y = ceil(slide_in_movement.y)
            elseif phase == "present" then
                x = ceil(present_movement.x)
                y = ceil(present_movement.y)
            elseif phase == "slide_out" then
                x = flr(slide_out_movement.x)
                y = flr(slide_out_movement.y)
            end

            for dx = -1, 1 do
                for dy = -1, 1 do
                    print("boss", x + 10 + dx, y - 7 + dy, _color_8_red)
                end
            end
            print("boss", x + 10, y - 7, _m.bg_color)
            rectfill(x, y, x + _gaw - 1, y, _color_8_red)

            clip()
        end,
    }
end