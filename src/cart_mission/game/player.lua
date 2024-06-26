-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/player.lua  --
-- -- -- -- -- -- -- -- -- -- -- --

function new_player(params)
    local on_bullets_spawned, on_shockwave_triggered = new_throttle(params.on_bullets_spawned), new_throttle(params.on_shockwave_triggered)
    local w, h, on_damaged, on_destroyed = 10, 12, params.on_damaged, params.on_destroyed

    local ship_sprite_neutral, ship_sprite_flying_left, ship_sprite_flying_right = new_static_sprite "10,10,19,0", new_static_sprite "10,10,9,0", new_static_sprite "10,10,29,0"
    local jet_sprite_visible = new_animated_sprite(
        4,
        20,
        split("0,0,0,0,4,4,4,4"),
        9
    )
    local jet_sprite_hidden = _noop_game_object

    local ship_sprite_current, jet_sprite = ship_sprite_neutral, jet_sprite_visible

    local invincible_after_damage_timer, invincibility_flash_duration, is_destroyed, xy = nil, 6, false, _xy(_gaw / 2, _gah - 28)

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

        set_movement = function(left, right, up, down, fast_movement)
            jet_sprite = down and jet_sprite_hidden or jet_sprite_visible
            ship_sprite_current = left and ship_sprite_flying_left or (right and ship_sprite_flying_right or ship_sprite_neutral)

            local speed = fast_movement and 1.5 or 1
            local x_diff, y_diff = (right and speed or (left and -speed or 0)), (down and speed or (up and -speed or 0))
            if x_diff ~= 0 and y_diff ~= 0 then
                -- speed fix for a diagonal movement
                x_diff, y_diff = x_diff / 1.41, y_diff / 1.41
            end
            xy = _xy(
                mid(w / 2 + 1, xy.x + x_diff, _gaw - w / 2 - 1),
                mid(h / 2 + 1, xy.y + y_diff, _gah - h / 2 - 1)
            )
        end,

        fire = function(fast_shoot, triple_shoot)
            on_bullets_spawned.invoke_if_ready(
                triple_shoot and (fast_shoot and 10 or 16) or (fast_shoot and 8 or 12),
                triple_shoot and create_triple_bullets or create_single_bullet
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
                -- we start with "-1" in order to avoid 1 frame of non-flash due to how "%" works (see "_draw()")
                invincible_after_damage_timer = new_timer(5 * invincibility_flash_duration - 1)
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
            if invincible_after_damage_timer and invincible_after_damage_timer.ttl % (2 * invincibility_flash_duration) < invincibility_flash_duration then
                pal(split "1,7,7,7,7,7,7,7,7,7,7,7,7,7,7")
            end
            ship_sprite_current._draw(xy)
            jet_sprite._draw(xy)
            pal()
        end,

    }
end