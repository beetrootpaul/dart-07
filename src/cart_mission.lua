-- -- -- -- -- -- -- --
-- cart_mission.lua  --
-- -- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local cart_params = _parse_mission_cart_params()

    _copy_shared_assets_to_transferable_ram()

    menuitem(1, "exit to title", function()
        _load_main_cart {
            preselected_mission_number = _m.mission_number,
        }
    end)

    -- disable btnp repeating
    poke(0x5f5c, 255)

    current_screen = new_screen_mission_intro {
        health = cart_params.health ~= nil and cart_params.health or _health_default,
        shockwave_charges = cart_params.shockwave_charges ~= nil and cart_params.shockwave_charges or _shockwave_charges_default,
        triple_shot = cart_params.triple_shot ~= nil and cart_params.triple_shot or false,
        fast_shoot = cart_params.fast_shoot ~= nil and cart_params.fast_shoot or false,
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
