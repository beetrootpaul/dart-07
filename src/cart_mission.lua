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

    current_screen = new_screen_intro {
        health = cart_params.health ~= nil and cart_params.health or _health_default,
        is_triple_shot_enabled = cart_params.is_triple_shot_enabled ~= nil and cart_params.is_triple_shot_enabled or false,
        is_fast_shot_enabled = cart_params.is_fast_shot_enabled ~= nil and cart_params.is_fast_shot_enabled or false,
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
