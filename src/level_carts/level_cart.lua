-- -- -- -- -- -- -- -- -- -- --
-- level_carts/level_cart.lua --
-- -- -- -- -- -- -- -- -- -- --

local current_screen, next_screen

function _init()
    local score = tonum(split(stat(6))[1]) or 0
    local number = tonum(split(stat(6))[2]) or 0

    local src_addr = 0x4300
    memcpy(0x0, src_addr, 0x1000) -- copy sprite sheet, sections 1 and 2
    src_addr = src_addr + 0x1000
    --memcpy(0x3200, src_addr, 0x44 * 5) -- copy SFXs 0-5
    src_addr = src_addr + 0x44 * 5
    --memcpy(0x3200 + 0x44 * 20, src_addr, 0x44 * 5) -- copy SFXs 20-29

    menuitem(1, "-> to main <-", function()
        local params = current_screen.score() .. "," .. current_screen.number()
        load("shmup.p8", nil, params)
        load("shmup/shmup.p8", nil, params)
        load("#tmp_multicart_main", nil, params)
    end)
    next_screen = new_screen_get_ready(score, number)
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
