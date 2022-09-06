-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_over.lua  --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: create a decent game over screen

function new_screen_over()
    local fade_out = new_fade("out", 30)

    local retry = true
    local proceed = false

    --

    local screen = {}

    function screen._init()
        -- TODO: music
    end

    function screen._update()
        -- TODO: up/down SFX
        if btnp(_button_up) or btnp(_button_down) then
            retry = not retry
        end

        -- TODO: make it clear for the user which button is to be pressed
        if btnp(_button_x) then
            proceed = true
        end

        if proceed then
            fade_out._update()
        end
    end

    function screen._draw()
        cls(_color_0_black)

        print("try again (mission " .. _m.mission_number .. ")", 10, 40, retry and _color_6_light_grey or _color_13_mauve)
        print("back to title", 10, 60, retry and _color_13_mauve or _color_6_light_grey)
        print("score: ", 10, 80, _color_3_blue_green)
        -- TODO NEXT: implement and show conditionally
        print("new high score!", 10, 100, _color_3_blue_green)

        fade_out._draw()
    end

    function screen._post_draw()
        if fade_out.has_finished() then
            if retry then
                return new_screen_intro {
                    health = _health_default,
                    is_triple_shot_enabled = false,
                }
            else
                _load_main_cart {
                    preselected_mission_number = _m.mission_number,
                }
            end
        end
    end

    return screen
end
