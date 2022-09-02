-- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/player_bullet.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- --

function new_player_bullet(params)
    local start_x, start_y = params.start_x, params.start_y

    local is_destroyed = false

    local bullet_sprite = new_static_sprite(4, 6, 4, 12)

    local movement = new_movement_angled_line {
        start_x = start_x,
        start_y = start_y,
        base_speed_y = 0,
        angle = .25,
        angled_speed = 5,
    }

    return {
        has_finished = function()
            return is_destroyed or
                movement.x < _gaox - _ts or
                movement.x > _gaox + _gaw + _ts or
                movement.y < -_ts or
                movement.y > _gah + _ts
        end,

        collision_circle = function()
            return {
                x = movement.x - .5,
                y = movement.y - 1.5,
                r = 2,
            }
        end,

        destroy = function()
            is_destroyed = true
        end,

        _update = function()
            movement._update()
        end,

        _draw = function()
            bullet_sprite._draw(movement.x, movement.y)
        end,
    }
end

