-- -- -- -- -- -- -- --
-- cart_mission.lua  --
-- -- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    -- TODO: ?
    --local score = tonum(split(stat(6))[1]) or 0
    --local number = tonum(split(stat(6))[2]) or 0

    _copy_shared_assets_to_transferable_ram()

    -- TODO: decent polished menu item
    menuitem(1, "-> to main <-", function()
        _load_main_cart()
    end)

    -- TODO: start with get ready screen
    next_screen = new_screen_mission()
end

function _update()
    if current_screen ~= next_screen then
        next_screen.init()
    end
    current_screen = next_screen
    next_screen = current_screen.update()
end

function _draw()
    current_screen.draw()

    _remap_display_colors()
end