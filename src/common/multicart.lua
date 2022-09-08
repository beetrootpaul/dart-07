-- -- -- -- -- -- -- -- --
-- common/multicart.lua --
-- -- -- -- -- -- -- -- --

do

    _max_mission_number = 3

    local function get_cart_param_at(index)
        local cart_params = split(stat(6), ",", false)
        if #cart_params < index then
            return false
        end
        local p = cart_params[index]
        return #p > 0 and p or nil
    end

    function _parse_main_cart_params()
        local preselected_mission_number = get_cart_param_at(1)
        return {
            preselected_mission_number = preselected_mission_number ~= nil and tonum(preselected_mission_number) or nil,
        }
    end

    -- TODO: test fast shot passing from cart to cart
    function _parse_mission_cart_params()
        local health_param = get_cart_param_at(1)
        local is_triple_shot_enabled_param = get_cart_param_at(2)
        local is_fast_shot_enabled_param = get_cart_param_at(3)
        return {
            health = health_param ~= nil and tonum(health_param) or nil,
            triple_shot = is_triple_shot_enabled_param ~= nil and is_triple_shot_enabled_param == "true" or nil,
            fast_shoot = is_fast_shot_enabled_param ~= nil and is_fast_shot_enabled_param == "true" or nil,
        }
    end

    function _load_main_cart(params)
        local preselected_mission_number = params.preselected_mission_number

        local cart_params = tostr(preselected_mission_number)

        -- "load(…)" returns "false" if not failed and doesn't allow execution 
        -- of any further instruction if succeeded. This means we can safely
        -- try to load a cart under one of many possible file paths or BBS IDs.
        -- Please remember to load by BBS ID last, because we don't want online
        -- published version win with the locally developed one. Regarding local
        -- file paths, we use two variants here: one if we navigate in SPLORE to 
        -- inside of this game's directory and one if we started the game in 
        -- SPLORE from favorites tab (outside game's directory).
        load("shmup.p8", nil, cart_params)
        load("shmup/shmup.p8", nil, cart_params)
        -- TODO: use a nice final BBS cart ID here
        load("#tmp_multicart_main", nil, cart_params)
    end

    function _load_mission_cart(params)
        local mission_number = params.mission_number
        local health = params.health
        local triple_shot = params.triple_shot
        local fast_shoot = params.fast_shoot

        local cart_params = tostr(health) .. "," .. tostr(triple_shot) .. "," .. tostr(fast_shoot)

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

end