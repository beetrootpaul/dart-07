-- -- -- -- -- -- -- -- -- --
-- cart_mission/player.lua --
-- -- -- -- -- -- -- -- -- --

function new_player(params)
    local on_bullets_spawned = new_throttle(12, params.on_bullets_spawned)

    local w = 10
    local h = 10

    local speed = 1
    -- DEBUG:
    --local speed = 1

    local min_x = w / 2 + 1
    local max_x = _gaw - w / 2 - 1
    local min_y = h / 2 + 1
    local max_y = _gah - h / 2 - 1

    local ship_sprite_neutral = new_static_sprite(10, 10, 18, 0)
    local ship_sprite_flying_left = new_static_sprite(10, 10, 8, 0)
    local ship_sprite_flying_right = new_static_sprite(10, 10, 28, 0)
    local ship_sprite_current = ship_sprite_neutral

    local jet_sprite_visible = new_animated_sprite(
        4,
        4,
        split("0,0,0,0,4,4,4,4"),
        8
    )
    -- TODO: consider jet sprite small instead of hidden
    local jet_sprite_hidden = new_fake_sprite()
    local jet_sprite = jet_sprite_visible

    local invincible_after_damage_timer

    -- TODO: consider merging mission intro with enemies screen? It would simplify callback setting logic
    local on_destroyed = _noop

    local xy = _xy(_gaw / 2, _gah - 28)

    local function collision_circle()
        return {
            xy = xy,
            r = 4,
        }
    end

    -- 

    return {

        set_movement = function(left, right, up, down)
            jet_sprite = down and jet_sprite_hidden or jet_sprite_visible
            ship_sprite_current = left and ship_sprite_flying_left or (right and ship_sprite_flying_right or ship_sprite_neutral)
            xy = xy
                .set_x(mid(min_x, xy.x + (right and speed or (left and -speed or 0)), max_x))
                .set_y(mid(min_y, xy.y + (down and speed or (up and -speed or 0)), max_y))
        end,

        set_on_destroyed = function(callback)
            on_destroyed = callback
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

        collision_circle = collision_circle,

        is_invincible_after_damage = function()
            return invincible_after_damage_timer ~= nil
        end,

        take_damage = function(updated_health)
            if updated_health > 0 then
                -- TODO: SFX
                invincible_after_damage_timer = new_timer(30)
            else
                -- TODO: SFX
                on_destroyed(collision_circle())
            end
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
            local flash = invincible_after_damage_timer and flr(invincible_after_damage_timer.ttl / 8) % 2 == 1
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