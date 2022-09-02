-- -- -- -- -- -- -- --
-- cart_mission.lua  --
-- -- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local health = tonum(stat(6)) or _health_default
    -- TODO: ?
    --local score = tonum(split(stat(6))[1]) or 0
    --local number = tonum(split(stat(6))[2]) or 0

    _copy_shared_assets_to_transferable_ram()

    -- TODO: decent polished menu item
    menuitem(1, "-> to main <-", function()
        _load_main_cart()
    end)

    current_screen = new_screen_intro {
        health = health,
    }
end

function _update()
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
