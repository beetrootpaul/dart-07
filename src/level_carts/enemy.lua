-- -- -- -- -- -- -- -- -- --
-- level_carts/enemy.lua   --
-- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_type = params.enemy_type

    local x, y = params.x, params.y

    -- TODO: split enemy-specific code into separate files
    local ship_sprite
    if enemy_type == "sinusoidal" then
        ship_sprite = new_static_sprite({
            sprite_x = 18,
            sprite_y = 8,
            sprite_w = 7,
            sprite_h = 8,
        })
    elseif enemy_type == "wait_then_charge" then
        ship_sprite = new_static_sprite({
            sprite_x = 18,
            sprite_y = 0,
            sprite_w = 10,
            sprite_h = 8,
        })
    elseif enemy_type == "stationary" then
        ship_sprite = new_static_sprite({
            sprite_x = 32,
            sprite_y = 0,
            sprite_w = 16,
            sprite_h = 16,
        })
    end

    local age = 0

    -- TODO: make collision detection work only if at least 1px of the enemy is visible, not before
    return {
        has_finished = function()
            return x < -_ts
        end,
        update = function()
            -- TODO: split enemy-specific code into separate files
            if enemy_type == "sinusoidal" then
                x = x - 1
                y = y + 2 * sin(age / 60)
            elseif enemy_type == "wait_then_charge" then
                if age < 40 then
                    x = x - 1
                else
                    x = x - 3
                end
            elseif enemy_type == "stationary" then
                x = x - _ts * _distance_scroll_per_frame
            end
            age = age + 1
        end,

        draw = function()
            ship_sprite.draw(x, y)
        end,
    }
end