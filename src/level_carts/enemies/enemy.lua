-- -- -- -- -- -- -- -- -- -- -- --
-- level_carts/enemies/enemy.lua --
-- -- -- -- -- -- -- -- -- -- -- --

function new_enemy(enemy_type, start_x, start_y)
    local armor
    local movement
    local ship_sprite
    local collision_circle_r, collision_circle_offset_x
    
    local is_destroyed = false

    if enemy_type == "sinusoidal" then
        armor = 1
        movement = new_movement_sinusoidal(start_x, start_y)
        ship_sprite = new_static_sprite({
            sprite_x = 18,
            sprite_y = 12,
            sprite_w = 7,
            sprite_h = 6,
            transparent_color = _color_11_dark_green,
        })
        collision_circle_offset_x = -1
        collision_circle_r = 3
    elseif enemy_type == "wait_then_charge" then
        armor = 3
        movement = new_movement_wait_then_charge(start_x, start_y)
        ship_sprite = new_static_sprite({
            sprite_x = 18,
            sprite_y = 0,
            sprite_w = 10,
            sprite_h = 12,
            transparent_color = _color_11_dark_green,
        })
        collision_circle_offset_x = 1
        collision_circle_r = 5
    elseif enemy_type == "stationary" then
        armor = 6
        movement = new_movement_stationary(start_x, start_y)
        ship_sprite = new_static_sprite({
            sprite_x = 32,
            sprite_y = 0,
            sprite_w = 16,
            sprite_h = 16,
            transparent_color = _color_11_dark_green,
        })
        collision_circle_offset_x = 0
        collision_circle_r = 8
    end

    -- TODO: make collision detection work only if at least 1px of the enemy is visible, not before
    return {
        has_finished = function()
            return is_destroyed or movement.x < -_ts
        end,

        collision_circle = function()
            return {
                x = movement.x - .5 + collision_circle_offset_x,
                y = movement.y - .5,
                r = collision_circle_r,
            }
        end,
        
        take_damage = function()
            armor = armor - 1
            if armor < 1 then
                is_destroyed = true
            end
        end,

        move = function()
            movement.move()
        end,

        draw = function()
            ship_sprite.draw(movement.x, movement.y)
        end,
    }
end