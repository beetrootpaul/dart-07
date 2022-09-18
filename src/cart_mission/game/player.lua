-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/player.lua  --
-- -- -- -- -- -- -- -- -- -- -- --

function new_player(params)
    local on_bullets_spawned, on_shockwave_triggered = new_throttle(params.on_bullets_spawned), new_throttle(params.on_shockwave_triggered)
    local on_damaged, on_destroyed = params.on_damaged, params.on_destroyed

    local w, h, speed = 10, 12, 1

    local ship_sprite_neutral, ship_sprite_flying_left, ship_sprite_flying_right = new_static_sprite "10,10,18,0", new_static_sprite "10,10,8,0", new_static_sprite "10,10,28,0"
    local ship_sprite_current = ship_sprite_neutral

    local jet_sprite_visible = new_animated_sprite(
        4,
        4,
        split("0,0,0,0,4,4,4,4"),
        8
    )
    local jet_sprite_hidden = new_fake_sprite()
    local jet_sprite = jet_sprite_visible

    local invincible_after_damage_timer, invincibility_flash_duration = nil, 6

    local is_destroyed, xy = false, _xy(_gaw / 2, _gah - 28)

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

    local player = {
        is_invincible_after_damage = false,
    }

    function player.has_finished()
        return is_destroyed
    end

    function player.set_movement(left, right, up, down)
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
    end

    function player.fire(p)
        on_bullets_spawned.invoke_if_ready(
            p.fast_shoot and 8 or 14,
            p.triple_shot and create_triple_bullets or create_single_bullet
        )
    end

    function player.trigger_shockwave()
        on_shockwave_triggered.invoke_if_ready(
            6,
            create_shockwave
        )
    end

    function player.collision_circle()
        return {
            xy = xy.plus(0, 1),
            r = 3,
        }
    end

    function player.take_damage(updated_health)
        if updated_health > 0 then
            -- we start with "-1" in order to avoid 1 frame of non-flash due to how "%" works (see "_draw()")
            invincible_after_damage_timer = new_timer(5 * invincibility_flash_duration - 1, {
                on_finished = function()
                    player.is_invincible_after_damage = false
                    invincible_after_damage_timer = nil
                end
            })
            player.is_invincible_after_damage = true
            on_damaged()
        else
            is_destroyed = true
            on_destroyed(player.collision_circle())
        end
    end

    function player._update()
        if invincible_after_damage_timer then
            invincible_after_damage_timer._update()
        end

        on_bullets_spawned._update()
        on_shockwave_triggered._update()

        jet_sprite._update()
    end

    function player._draw()
        if invincible_after_damage_timer and invincible_after_damage_timer.ttl % (2 * invincibility_flash_duration) < invincibility_flash_duration then
            pal(split "1,7,7,7,7,7,7,7,7,7,7,7,7,7,7")
        end
        ship_sprite_current._draw(xy)
        jet_sprite._draw(xy.plus(0, 8))
        pal()
    end

    return player
end