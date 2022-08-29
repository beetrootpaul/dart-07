-- -- -- -- -- -- -- -- -- --
-- level_carts/powerup.lua --
-- -- -- -- -- -- -- -- -- --

-- TODO: fancy animation
-- TODO: actions on pick up
-- TODO: magnet for an easier pickup?

function new_powerup(params)
    local powerup_type = params.powerup_type
    local x, y = params.x, params.y

    local sprite

    if powerup_type == "a" then
        sprite = new_static_sprite {
            sprite_x = 121,
            sprite_y = 0,
            sprite_w = 7,
            sprite_h = 8,
            transparent_color = _color_11_dark_green,
        }
    elseif powerup_type == "t" then
        sprite = new_static_sprite {
            sprite_x = 113,
            sprite_y = 0,
            sprite_w = 7,
            sprite_h = 8,
            transparent_color = _color_11_dark_green,
        }
    end

    return {
        has_finished = function()
            -- TODO: support picked up powerup as well 
            return x < 0 - _ts or x > _gaw + _ts or y < _gaoy - _ts or y > _gaoy + _gah + _ts
        end,

        move = function()
            x = x - 1
        end,

        draw = function()
            sprite.draw(x, y)
        end
    }
end

