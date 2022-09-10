-- -- -- -- -- -- -- --
-- cart_mission.lua  --
-- -- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local health_param = _get_cart_param(1)
    local shockwave_charges_param = _get_cart_param(2)
    local is_triple_shot_enabled_param = _get_cart_param(3)
    local is_fast_shot_enabled_param = _get_cart_param(4)

    _copy_shared_assets_to_transferable_ram()

    -- to clear cart data, go to cart data folder (defined as "root_path" in "$HOME/Library/Application Support/pico-8/config.txt")
    -- and delete "todo-shmup.p8d.txt" file
    cartdata("todo-shmup")

    menuitem(1, "exit to title", function()
        _load_main_cart {
            preselected_mission_number = _m.mission_number,
        }
    end)

    -- disable btnp repeating
    poke(0x5f5c, 255)

    current_screen = new_screen_mission_main {
        health = health_param ~= nil and tonum(health_param) or _health_default,
        shockwave_charges = shockwave_charges_param ~= nil and tonum(shockwave_charges_param) or _shockwave_charges_default,
        triple_shot = is_triple_shot_enabled_param == "true",
        fast_shoot = is_fast_shot_enabled_param == "true",
    }
    current_screen._init()
end

function _update60()
    next_screen = current_screen._post_draw()

    if next_screen then
        current_screen = next_screen
        current_screen._init()
    end

    current_screen._update()
end

function _draw()
    current_screen._draw()

    _remap_display_colors()
end
