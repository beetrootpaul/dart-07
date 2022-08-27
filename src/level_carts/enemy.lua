-- -- -- -- -- -- -- -- -- --
-- level_carts/enemy.lua   --
-- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_type = params.enemy_type

    local x, y, w, h, ship_sprite

    -- TODO: REVISIT XY SETTING
    -- TODO: split enemy-specific code into separate files
    if enemy_type == "sinusoidal" then
        w, h = 7, 6
        x, y = params.center_x - w / 2, params.center_y - h / 2
        ship_sprite = new_static_sprite({
            sprite_w = w,
            sprite_h = h,
            sprite_x = 18,
            sprite_y = 8,
        })
    elseif enemy_type == "wait_then_charge" then
        w, h = 10, 8
        x, y = params.center_x - w / 2, params.center_y - h / 2
        ship_sprite = new_static_sprite({
            sprite_w = w,
            sprite_h = h,
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
            ship_sprite.draw(x, flr(y))
        end,
    }
end