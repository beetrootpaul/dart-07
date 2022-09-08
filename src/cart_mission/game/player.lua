-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/player.lua  --
-- -- -- -- -- -- -- -- -- -- -- --

function new_player(params)
    local on_bullets_spawned = new_throttle(params.on_bullets_spawned)
    local on_shockwave_triggered = new_throttle(params.on_shockwave_triggered)
    local on_destroyed = params.on_destroyed

    local w = 10
    local h = 10

    local speed = 1

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
    local jet_sprite_hidden = new_fake_sprite()
    local jet_sprite = jet_sprite_visible

    local invincible_after_damage_timer

    local is_destroyed = false

    local xy = _xy(_gaw / 2, _gah - 28)

    local function collision_circle()
        return {
            xy = xy,
            r = 4,
        }
    end

    -- 

    return {

        has_finished = function()
            return is_destroyed
        end,

        set_movement = function(left, right, up, down)
            jet_sprite = down and jet_sprite_hidden or jet_sprite_visible
            ship_sprite_current = left and ship_sprite_flying_left or (right and ship_sprite_flying_right or ship_sprite_neutral)
            xy = xy
                .set_x(mid(
                w / 2 + 1,
                xy.x + (right and speed or (left and -speed or 0)),
                _gaw - w / 2 - 1
            ))
                .set_y(mid(
                h / 2 + 1,
                xy.y + (down and speed or (up and -speed or 0)),
                _gah - h / 2 - 1
            ))
        end,

        fire = function(p)
            local bullets = {
                -- TODO: SFX?
                new_player_bullet(xy.plus(0, -4)),
            }
            if p.triple_shot then
                -- TODO: different SFX?
                add(bullets, new_player_bullet(xy.plus(-5, -2)))
                add(bullets, new_player_bullet(xy.plus(5, -2)))
            end
            on_bullets_spawned.invoke(
            -- TODO: balancing
                p.fast_shoot and 9 or 18,
                bullets
            )
        end,

        trigger_shockwave = function()
            on_shockwave_triggered.invoke(6, new_shockwave(xy, 1))
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
                is_destroyed = true
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
            on_shockwave_triggered._update()

            jet_sprite._update()
        end,

        _draw = function()
            local flash_color = invincible_after_damage_timer and
                flr(invincible_after_damage_timer.ttl / 8) % 2 == 1 and
                _color_6_light_grey or
                nil
            -- TODO: consider blinking instead of flashing
            ship_sprite_current._draw(xy, {
                flash_color = flash_color,
            })
            jet_sprite._draw(xy.plus(0, 8), {
                flash_color = flash_color,
            })
        end,

    }
end