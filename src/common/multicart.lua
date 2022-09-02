-- -- -- -- -- -- -- -- --
-- common/multicart.lua --
-- -- -- -- -- -- -- -- --

_max_mission_number = 3

function _load_main_cart()
    -- TODO: ?
    --local params = current_screen.score() .. "," .. current_screen.number()
    --load("shmup.p8", nil, params)

    -- "load(…)" returns "false" if not failed and doesn't allow execution 
    -- of any further instruction if succeeded. This means we can safely
    -- try to load a cart under one of many possible file paths or BBS IDs.
    -- Please remember to load by BBS ID last, because we don't want online
    -- published version win with the locally developed one. Regarding local
    -- file paths, we use two variants here: one if we navigate in SPLORE to 
    -- inside of this game's directory and one if we started the game in 
    -- SPLORE from favorites tab (outside game's directory).
    load("shmup.p8")
    load("shmup/shmup.p8")
    -- TODO: use a nice final BBS cart ID here
    load("#tmp_multicart_main")
end

function _load_mission_cart(params)
    local mission_number = params.mission_number
    local health = params.health
    local is_triple_shot_enabled = params.is_triple_shot_enabled

    local cart_params = tostr(health) .. "," .. tostr(is_triple_shot_enabled)

    -- "load(…)" returns "false" if not failed and doesn't allow execution 
    -- of any further instruction if succeeded. This means we can safely
    -- try to load a cart under one of many possible file paths or BBS IDs.
    -- Please remember to load by BBS ID last, because we don't want online
    -- published version win with the locally developed one. Regarding local
    -- file paths, we use two variants here: one if we navigate in SPLORE to 
    -- inside of this game's directory and one if we started the game in 
    -- SPLORE from favorites tab (outside game's directory).
    -- TODO: add to PICO-8 API file
    load("shmup-mission-" .. mission_number .. ".p8", nil, cart_params)
    load("shmup/shmup-mission-" .. mission_number .. ".p8", nil, cart_params)
    -- TODO: use a nice final BBS cart ID here
    load("#tmp_multicart_lvl" .. mission_number, nil, cart_params)
end

function _parse_mission_cart_params()
    local cart_params = stat(6)
    return {
        health = tonum(split(cart_params)[1] or tostr(_health_default)),
        is_triple_shot_enabled = split(cart_params)[2] == "true",
    }
end

function _copy_shared_assets_to_transferable_ram()
    -- TODO: ?
    --local src_addr = 0x4300
    --memcpy(0x0, src_addr, 0x1000) -- copy sprite sheet, sections 1 and 2
    --src_addr = src_addr + 0x1000
    --memcpy(0x3200, src_addr, 0x44 * 5) -- copy SFXs 0-5
    --src_addr = src_addr + 0x44 * 5
    --memcpy(0x3200 + 0x44 * 20, src_addr, 0x44 * 5) -- copy SFXs 20-29

    -- TODO: assert if within ranges on both sides
    -- TODO: explain thoroughly in a comment
    -- TODO: add to PICO-8 API file
    memcpy(0x0, 0x4300, 0x0800) -- copy first sprite sheet tab
end

function _copy_shared_assets_from_transferable_ram()
    -- TODO: ?
    -- user data addresses: 0x4300 .. 0x55ff
    --local expected_max_addr = 0x4300 + 0x1000 + 0x44 * 5 + 0x44 * 5
    --assert(expected_max_addr < 0x55ff, tostr(expected_max_addr, 0x1) .. " :-(")
    --local dest_addr = 0x4300
    --memcpy(dest_addr, 0x0, 0x1000) -- copy sprite sheet, sections 1 and 2
    --dest_addr = dest_addr + 0x1000
    --memcpy(dest_addr, 0x3200, 0x44 * 5) -- copy SFXs 0-5
    --dest_addr = dest_addr + 0x44 * 5
    --memcpy(dest_addr, 0x3200 + 0x44 * 20, 0x44 * 5) -- copy SFXs 20-25
    --dest_addr = dest_addr + 0x44 * 5
    --assert(expected_max_addr == dest_addr, "should be equal")

    -- TODO: assert if within ranges on both sides
    -- TODO: explain thoroughly in a comment
    memcpy(0x4300, 0x0, 0x0800) -- copy first sprite sheet tab
end