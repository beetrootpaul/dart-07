-- -- -- -- -- -- -- -- -- --
-- level_carts/player.lua  --
-- -- -- -- -- -- -- -- -- --

-- TODO: consider rotating the whole game to vertical scroller

function new_player()
    local w = 10
    local h = 10
    local x = 12
    local y = _gaoy + _gah / 2
    local speed = 2

    local min_x = w / 2 + 1
    local max_x = _gaw - w / 2 - 1
    local min_y = _gaoy + h / 2 + 1
    local max_y = _gaoy + _gah - h / 2 - 1

    local ship_sprite_neutral = new_static_sprite({
        sprite_w = 10,
        sprite_h = 10,
        sprite_x = 8,
        sprite_y = 10,
    })
    local ship_sprite_flying_left = new_static_sprite({
        sprite_w = 10,
        sprite_h = 10,
        sprite_x = 8,
        sprite_y = 0,
    })
    local ship_sprite_flying_right = new_static_sprite({
        sprite_w = 10,
        sprite_h = 10,
        sprite_x = 8,
        sprite_y = 20,
    })
    local ship_sprite_current = ship_sprite_neutral

    local jet_sprite_visible = new_animated_sprite {
        sprite_w = 4,
        sprite_h = 4,
        sprite_xs = { 4, 4, 0, 0 },
        sprite_y = 8,
    }
    local jet_sprite_hidden = new_fake_sprite()
    local jet_sprite = jet_sprite_visible

    local invincible_after_damage_timer

    return {
        set_horizontal_movement = function(direction)
            if direction == "l" then
                x = max(x - speed, min_x)
                jet_sprite = jet_sprite_hidden
            elseif direction == "r" then
                x = min(x + speed, max_x)
                jet_sprite = jet_sprite_visible
            else
                jet_sprite = jet_sprite_visible
            end
        end,

        set_vertical_movement = function(direction)
            if direction == "u" then
                y = max(y - speed, min_y)
                ship_sprite_current = ship_sprite_flying_left
            elseif direction == "d" then
                y = min(y + speed, max_y)
                ship_sprite_current = ship_sprite_flying_right
            else
                ship_sprite_current = ship_sprite_neutral
            end
        end,

        collision_circle = function()
            return {
                x = x - 1.5,
                y = y - .5,
                r = 4,
            }
        end,

        is_invincible_after_damage = function()
            return invincible_after_damage_timer ~= nil
        end,
        start_invincibility_after_damage = function()
            invincible_after_damage_timer = new_timer(30)
        end,

        advance_timers = function()
            if invincible_after_damage_timer then
                if invincible_after_damage_timer.ttl <= 0 then
                    invincible_after_damage_timer = nil
                else
                    invincible_after_damage_timer.advance()
                end
            end
        end,

        animate = function()
            jet_sprite.animate()
        end,

        draw = function()
            if invincible_after_damage_timer and flr(invincible_after_damage_timer.ttl / 4) % 2 == 1 then
                ship_sprite_current.draw(x, y, {
                    -- TODO: make it pure white?
                    flash_color = _color_6_light_grey,
                })
                jet_sprite.draw(x - 8, y, {
                    -- TODO: make it pure white?
                    flash_color = _color_6_light_grey,
                })
            else
                ship_sprite_current.draw(x, y)
                jet_sprite.draw(x - 8, y)
            end
        end,
    }
end