-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/player.lua  --
-- -- -- -- -- -- -- -- -- -- -- --

function new_player(params)
    local on_bullets_spawned = new_throttle(params.on_bullets_spawned)
    local on_shockwave_triggered = new_throttle(params.on_shockwave_triggered)
    local on_damaged, on_destroyed = params.on_damaged, params.on_destroyed

    local w, h, speed = 10, 12, 1

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
            xy = xy.plus(0, 1),
            r = 3,
        }
    end

    local function create_single_bullet()
        return {
            new_player_bullet(xy.plus(0, -4)),
        }
    end

    local function create_triple_bullets()
        return {
            new_player_bullet(xy.plus(0, -4)),
            new_player_bullet(xy.plus(-5, -2)),
            new_player_bullet(xy.plus(5, -2)),
        }
    end

    local function create_shockwave()
        return new_shockwave(xy, 1)
    end

    -- 

    return {

        has_finished = function()
            return is_destroyed
        end,

        set_movement = function(left, right, up, down)
            jet_sprite = down and jet_sprite_hidden or jet_sprite_visible
            ship_sprite_current = left and ship_sprite_flying_left or (right and ship_sprite_flying_right or ship_sprite_neutral)
            xy = _xy(
                mid(
                    w / 2 + 1,
                    xy.x + (right and speed or (left and -speed or 0)),
                    _gaw - w / 2 - 1
                ),
                mid(
                    h / 2 + 1,
                    xy.y + (down and speed or (up and -speed or 0)),
                    _gah - h / 2 - 1
                ))
        end,

        fire = function(p)
            on_bullets_spawned.invoke_if_ready(
                p.fast_shoot and 8 or 14,
                p.triple_shot and create_triple_bullets or create_single_bullet
            )
        end,

        trigger_shockwave = function()
            on_shockwave_triggered.invoke_if_ready(
                6,
                create_shockwave
            )
        end,

        collision_circle = collision_circle,

        is_invincible_after_damage = function()
            return invincible_after_damage_timer ~= nil
        end,

        take_damage = function(updated_health)
            if updated_health > 0 then
                invincible_after_damage_timer = new_timer(30)
                on_damaged()
            else
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
            ship_sprite_current._draw(xy, {
                flash_color = flash_color,
            })
            jet_sprite._draw(xy.plus(0, 8), {
                flash_color = flash_color,
            })
        end,

    }
end