-- -- -- -- -- -- -- -- -- --
-- level_carts/player.lua  --
-- -- -- -- -- -- -- -- -- --

-- TODO: consider rotating the whole game to vertical scroller

function new_player()
    local w = 10
    local h = 10
    local x = 12
    local y = _gaoy + flr((_gah - h) / 2)
    local speed = 2

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

    return {
        -- TODO: boundaries
        update = function()
            if btn(_button_left) then
                x = x - speed
                jet_sprite = jet_sprite_hidden
            elseif btn(_button_right) then
                x = x + speed
                jet_sprite = jet_sprite_visible
            else
                jet_sprite = jet_sprite_visible
            end

            if btn(_button_up) then
                y = y - speed
                ship_sprite_current = ship_sprite_flying_left
            elseif btn(_button_down) then
                y = y + speed
                ship_sprite_current = ship_sprite_flying_right
            else
                ship_sprite_current = ship_sprite_neutral
            end

            jet_sprite.update()
        end,

        draw = function()
            ship_sprite_current.draw(x, y)
            jet_sprite.draw(x - 5, y + 3)
        end,
    }
end