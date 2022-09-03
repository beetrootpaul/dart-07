-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/gui/boss_info.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: better boss info GUI

function new_boss_info(params)
    local slide_in_frames = params.slide_in_frames
    local present_frames = params.present_frames
    local slide_out_frames = params.slide_out_frames

    local slide_in_movement = new_movement_to_target_factory {
        target_xy = _xy(_gaox, _gah / 2),
        frames = slide_in_frames,
        easing_fn = _easing_easeoutquart,
    }(_xy(_gaox, -1))
    local present_movement = new_movement_fixed_factory {
        frames = present_frames,
    }(_xy(_gaox, _gah / 2))
    local slide_out_movement = new_movement_to_target_factory {
        target_xy = _xy(_gaox, _gah + 1),
        frames = slide_out_frames,
        easing_fn = _easing_easeinquart,
    }(_xy(_gaox, _gah / 2))

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

            -- TODO: make it a movement_sequence(cycle=false)
            local xy
            if phase == "slide_in" then
                xy = slide_in_movement.xy.ceil()
            elseif phase == "present" then
                xy = present_movement.xy.ceil()
            elseif phase == "slide_out" then
                xy = slide_out_movement.xy.flr()
            end

            for dx = -1, 1 do
                for dy = -1, 1 do
                    print("boss", xy.x + 10 + dx, xy.y - 7 + dy, _color_8_red)
                end
            end
            print("boss", xy.x + 10, xy.y - 7, _m.bg_color)
            rectfill(xy.x, xy.y, xy.x + _gaw - 1, xy.y, _color_8_red)

            clip()
        end,
    }
end