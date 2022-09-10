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
        local shockwave_charges_param = get_cart_param_at(2)
        local is_triple_shot_enabled_param = get_cart_param_at(3)
        local is_fast_shot_enabled_param = get_cart_param_at(4)
        return {
            health = health_param ~= nil and tonum(health_param) or nil,
            shockwave_charges = shockwave_charges_param ~= nil and tonum(shockwave_charges_param) or nil,
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
        local shockwave_charges = params.shockwave_charges
        local triple_shot = params.triple_shot
        local fast_shoot = params.fast_shoot

        local cart_params = tostr(health) .. "," .. tostr(shockwave_charges) .. "," .. tostr(triple_shot) .. "," .. tostr(fast_shoot)

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

    local memory_sprite_sheet_start = 0x0000

    -- TODO: add MEMCPY to PICO-8 API file

    -- docs about memory space:
    --   - https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Memory
    --   - https://pico-8.fandom.com/wiki/Memory
    function _copy_shared_assets_to_transferable_ram()
        -- 0x0000 = start of sprite sheet tabs 1-2
        -- 0x1000 = start of sprite sheet tabs 3-4, just after end of tabs 1-2
        -- 0x3200 = start of 64 SFXs (therefore length of 32 SFXs = (0x4300-0x3200)/2 = 0x880
        -- 0x4300 = user data start (transferable between carts), just after end of SFXs
        -- 0x5600 = custom font, just after end of user data

        -- copy first tab of the sprite sheet
        memcpy(0x0000, 0x4300, 0x0800)
        -- copy first 32 SFXs
        memcpy(0x3200, 0x4b00, 0x0880)
        -- we reached address 0x537f so far, which is within range of the user data 
    end

    -- docs about memory space:
    --   - https://www.lexaloffle.com/dl/docs/pico-8_manual.html#Memory
    --   - https://pico-8.fandom.com/wiki/Memory
    function _copy_shared_assets_from_transferable_ram()
        -- 0x0000 = start of sprite sheet tabs 1-2
        -- 0x1000 = start of sprite sheet tabs 3-4, just after end of tabs 1-2
        -- 0x3200 = start of 64 SFXs (therefore length of 32 SFXs = (0x4300-0x3200)/2 = 0x880
        -- 0x4300 = user data start (transferable between carts), just after end of SFXs
        -- 0x5600 = custom font, just after end of user data

        -- copy first tab of the sprite sheet
        memcpy(0x4300, 0x0000, 0x0800)
        -- copy first 32 SFXs
        memcpy(0x4b00, 0x3200, 0x0880)
    end

end