-- -- -- -- -- -- -- -- -- --
-- cart_mission/player.lua --
-- -- -- -- -- -- -- -- -- --

-- TODO: consider rotating the whole game to vertical scroller

function new_player()
    local w = 10
    local h = 10
    local speed = 2

    local min_x = _gaox + w / 2 + 1
    local max_x = _gaox + _gaw - w / 2 - 1
    local min_y = h / 2 + 1
    local max_y = _gah - h / 2 - 1

    local ship_sprite_neutral = new_static_sprite(10, 10, 18, 0, {
        transparent_color = _color_11_dark_green,
    })
    local ship_sprite_flying_left = new_static_sprite(10, 10, 8, 0, {
        transparent_color = _color_11_dark_green,
    })
    local ship_sprite_flying_right = new_static_sprite(10, 10, 28, 0, {
        transparent_color = _color_11_dark_green,
    })
    local ship_sprite_current = ship_sprite_neutral

    local jet_sprite_visible = new_animated_sprite {
        sprite_w = 4,
        sprite_h = 4,
        sprite_xs = { 0, 0, 4, 4 },
        sprite_y = 8,
    }
    local jet_sprite_hidden = new_fake_sprite()
    local jet_sprite = jet_sprite_visible

    local invincible_after_damage_timer

    -- 

    local player = {
        x = _gaox + _gaw / 2,
        y = _gah - 28,
    }

    function player.set_vertical_movement(direction)
        if direction == "u" then
            player.y = max(player.y - speed, min_y)
            jet_sprite = jet_sprite_visible
        elseif direction == "d" then
            player.y = min(player.y + speed, max_y)
            jet_sprite = jet_sprite_hidden
        else
            jet_sprite = jet_sprite_visible
        end
    end

    function player.set_horizontal_movement(direction)
        if direction == "l" then
            player.x = max(player.x - speed, min_x)
            ship_sprite_current = ship_sprite_flying_left
        elseif direction == "r" then
            player.x = min(player.x + speed, max_x)
            ship_sprite_current = ship_sprite_flying_right
        else
            ship_sprite_current = ship_sprite_neutral
        end
    end

    function player.collision_circle()
        return {
            x = player.x - .5,
            y = player.y + .5,
            r = 4,
        }
    end

    function player.is_invincible_after_damage()
        return invincible_after_damage_timer ~= nil
    end

    function player.start_invincibility_after_damage()
        -- TODO: SFX
        invincible_after_damage_timer = new_timer(30)
    end

    function player._update()
        if invincible_after_damage_timer then
            if invincible_after_damage_timer.ttl <= 0 then
                invincible_after_damage_timer = nil
            else
                invincible_after_damage_timer._update()
            end
        end

        jet_sprite._update()
    end

    function player._draw()
        local flash = invincible_after_damage_timer and flr(invincible_after_damage_timer.ttl / 4) % 2 == 1
        ship_sprite_current._draw(player.x, player.y, {
            -- TODO: make it pure white?
            flash_color = flash and _color_6_light_grey or nil,
        })
        jet_sprite._draw(player.x, player.y + 8, {
            -- TODO: make it pure white?
            flash_color = flash and _color_6_light_grey or nil,
        })
    end

    return player
end