-- -- -- -- -- -- -- -- -- -- --
-- cart_main/screen_over.lua  --
-- -- -- -- -- -- -- -- -- -- --

-- TODO: create a decent game over screen
-- TODO: refactor option selection management?

function new_screen_over()
    local retry = true
    local proceed = false

    --

    local screen = {}

    function screen._init()
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
    end

    function screen._draw()
        cls(_color_0_black)

        print("try again (mission " .. _m.mission_number .. ")", 10, 40, retry and _color_6_light_grey or _color_13_mauve)
        print("back to title", 10, 60, retry and _color_13_mauve or _color_6_light_grey)
        print("score: ", 10, 80, _color_3_blue_green)
        -- TODO: implement and show conditionally
        print("new high score!", 50, 100, _color_3_blue_green)
    end

    function screen._post_draw()
        if proceed then
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
