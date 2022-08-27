-- -- -- -- -- -- -- -- -- --
-- level_carts/enemy.lua   --
-- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_type = params.enemy_type

    local x, y = params.center_x, params.center_y

    -- TODO: split enemy-specific code into separate files
    local ship_sprite
    if enemy_type == "sinusoidal" then
        ship_sprite = new_static_sprite({
            sprite_w = 7,
            sprite_h = 8,
            sprite_x = 18,
            sprite_y = 8,
        })
    elseif enemy_type == "wait_then_charge" then
        ship_sprite = new_static_sprite({
            sprite_w = 10,
            sprite_h = 8,
            sprite_x = 18,
            sprite_y = 0,
        })
    end

    local age = 0

    return {
        has_finished = function()
            -- TODO: what exact number to put here to avoid sprites from disappearing to soon?
            return x < 0
        end,
        update = function()
            -- TODO: split enemy-specific code into separate files
            if enemy_type == "sinusoidal" then
                -- TODO: fix y range
                x = x - 1
                y = y + 2 * sin(age / 60)
            elseif enemy_type == "wait_then_charge" then
                if age < 20 then
                    x = x - 2

                elseif age < 70 then
                    -- do not move
                else
                    x = x - 4
                end
            end
            age = age + 1
        end,

        draw = function()
            ship_sprite.draw(x, y)
        end,
    }
end