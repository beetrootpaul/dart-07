-- -- -- -- -- -- -- -- -- --
-- cart_mission/player.lua --
-- -- -- -- -- -- -- -- -- --

function new_player()
    local w = 10
    local h = 10
    local speed = 2

    local min_x = w / 2 + 1
    local max_x = _gaw - w / 2 - 1
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

    local jet_sprite_visible = new_animated_sprite(4, 4, { 0, 0, 4, 4 }, 8)
    local jet_sprite_hidden = new_fake_sprite()
    local jet_sprite = jet_sprite_visible

    local on_bullets_spawned = new_throttle(6, _noop)

    local invincible_after_damage_timer

    local xy = _xy(_gaw / 2, _gah - 28)

    -- 

    return {

        set_movement = function(left, right, up, down)
            jet_sprite = down and jet_sprite_hidden or jet_sprite_visible
            ship_sprite_current = left and ship_sprite_flying_left or (right and ship_sprite_flying_right or ship_sprite_neutral)
            xy = xy
                .set_x(mid(min_x, xy.x + (right and speed or (left and -speed or 0)), max_x))
                .set_y(mid(min_y, xy.y + (down and speed or (up and -speed or 0)), max_y))
        end,

        set_on_bullets_spawned = function(callback)
            on_bullets_spawned = new_throttle(6, callback)
        end,

        fire = function(p)
            local bullets = {
                -- TODO: SFX?
                new_player_bullet { start_xy = xy.plus(0, -4) },
            }
            if p.is_triple_shot_enabled then
                -- TODO: different SFX?
                add(bullets, new_player_bullet { start_xy = xy.plus(-5, -2) })
                add(bullets, new_player_bullet { start_xy = xy.plus(5, -2) })
            end
            on_bullets_spawned.invoke(bullets)
        end,

        collision_circle = function()
            return {
                xy = xy.plus(-.5, .5),
                r = 4,
            }
        end,

        is_invincible_after_damage = function()
            return invincible_after_damage_timer ~= nil
        end,

        start_invincibility_after_damage = function()
            -- TODO: SFX
            invincible_after_damage_timer = new_timer(30)
        end,

        _update = function()
            if invincible_after_damage_timer then
                if invincible_after_damage_timer.ttl <= 0 then
                    invincible_after_damage_timer = nil
                else
                    invincible_after_damage_timer._update()
                end
            end

            on_bullets_spawned._update()

            jet_sprite._update()
        end,

        _draw = function()
            local flash = invincible_after_damage_timer and flr(invincible_after_damage_timer.ttl / 4) % 2 == 1
            -- TODO: consider blinking instead of flashing
            ship_sprite_current._draw(xy, {
                -- TODO: make it pure white?
                flash_color = flash and _color_6_light_grey or nil,
            })
            jet_sprite._draw(xy.plus(0, 8), {
                -- TODO: make it pure white?
                flash_color = flash and _color_6_light_grey or nil,
            })
        end,

    }
end