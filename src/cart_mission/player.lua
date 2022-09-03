-- -- -- -- -- -- -- -- -- --
-- cart_mission/player.lua --
-- -- -- -- -- -- -- -- -- --

function new_player()
    local w = 10
    local h = 10
    local speed = 2

    -- TODO NEXT: rework where to refer to _gaox?
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
        xy = _xy(_gaox + _gaw / 2, _gah - 28)
    }

    function player.set_movement(left, right, up, down)
        jet_sprite = down and jet_sprite_hidden or jet_sprite_visible
        ship_sprite_current = left and ship_sprite_flying_left or (right and ship_sprite_flying_right or ship_sprite_neutral)
        player.xy = player.xy
                          .set_x(mid(min_x, player.xy.x + (right and speed or (left and -speed or 0)), max_x))
                          .set_y(mid(min_y, player.xy.y + (down and speed or (up and -speed or 0)), max_y))
    end

    function player.collision_circle()
        return {
            xy = player.xy.plus(-.5, .5),
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
        ship_sprite_current._draw(player.xy, {
            -- TODO: make it pure white?
            flash_color = flash and _color_6_light_grey or nil,
        })
        jet_sprite._draw(player.xy.plus(0, 8), {
            -- TODO: make it pure white?
            flash_color = flash and _color_6_light_grey or nil,
        })
    end

    return player
end