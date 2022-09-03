-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/mission_info.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: better mission info GUI

function new_mission_info(params)
    local slide_in_frames = params.slide_in_frames
    local present_frames = params.present_frames
    local slide_out_frames = params.slide_out_frames

    -- TODO: use movement sequence and xy here
    local slide_in_timer = new_timer(slide_in_frames)
    -- TODO: externalize?
    local slide_in_y_initial = -1
    local slide_in_y_target = flr(_gah / 2)

    local present_timer = new_timer(present_frames)

    local slide_out_timer = new_timer(slide_out_frames)
    local slide_out_y_initial = slide_in_y_target
    local slide_out_y_target = _gah + 1

    -- phase: slide_in -> present -> slide_out
    local phase = "slide_in"

    return {
        _update = function()
            if phase == "slide_in" then
                if slide_in_timer.ttl > 0 then
                    slide_in_timer._update()
                else
                    phase = "present"
                    present_timer._update()
                end
            elseif phase == "present" then
                if present_timer.ttl > 0 then
                    present_timer._update()
                else
                    phase = "slide_out"
                    slide_out_timer._update()
                end
            elseif phase == "slide_out" then
                if slide_out_timer.ttl > 0 then
                    slide_out_timer._update()
                end
            end
        end,

        _draw = function()
            clip(_gaox, 0, _gaw, _gah)

            local y
            if phase == "slide_in" then
                y = ceil(_easing_lerp(
                    slide_in_y_initial,
                    slide_in_y_target,
                    _easing_easeoutquart(slide_in_timer.passed_fraction())
                ))
            elseif phase == "present" then
                y = slide_in_y_target
            elseif phase == "slide_out" then
                y = flr(_easing_lerp(
                    slide_out_y_initial,
                    slide_out_y_target,
                    _easing_easeinquart(slide_out_timer.passed_fraction())
                ))
            end

            for dx = -1, 1 do
                for dy = -1, 1 do
                    print("mission " .. _m.mission_number, _gaox + 10 + dx, y - 7 + dy, _color_8_red)
                end
            end
            print("mission " .. _m.mission_number, _gaox + 10, y - 7, _m.bg_color)
            rectfill(_gaox, y, _gaox + _gaw - 1, y, _color_8_red)

            clip()
        end,
    }
end