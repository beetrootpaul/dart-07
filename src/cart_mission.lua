-- -- -- -- -- -- -- --
-- cart_mission.lua  --
-- -- -- -- -- -- -- --

local fade_out, current_screen, next_screen = _noop_game_object

function _init()
    local health_param, shockwave_charges_param, triple_shot_param, fast_shot_param, score_param = _get_cart_param(1), _get_cart_param(2), _get_cart_param(3), _get_cart_param(4), _get_cart_param(5)

    _copy_shared_assets_to_transferable_ram()

    -- to clear cart data, go to cart data folder (defined as "root_path" in "$HOME/Library/Application Support/pico-8/config.txt")
    -- and delete "todo-shmup.p8d.txt" file
    cartdata("todo-shmup")

    menuitem(1, "exit to title", function()
        fade_out = new_fade("out", 30)
    end)

    -- disable btnp repeating
    poke(0x5f5c, 255)

    current_screen = new_screen_mission_main {
        health = health_param or _health_default,
        shockwave_charges = shockwave_charges_param or _shockwave_charges_default,
        triple_shot = triple_shot_param == "true",
        fast_shoot = fast_shot_param == "true",
        score = score_param or 0,
    }
    current_screen._init()
end

function _update60()
    if fade_out.has_finished() then
        _load_main_cart {
            preselected_mission_number = _m.mission_number,
        }
    end

    next_screen = current_screen._post_draw()

    if next_screen then
        current_screen = next_screen
        current_screen._init()
    end

    current_screen._update()

    fade_out._update()
end

function _draw()
    current_screen._draw()

    fade_out._draw()

    pal(_palette_display, 1)
end
