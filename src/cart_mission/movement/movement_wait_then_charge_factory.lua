-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/movement/movement_wait_then_charge_factory.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- TODO: replace with a sequence of movements
function new_movement_wait_then_charge_factory()
    return function(start_xy)
        -- TODO: use timer instead
        local age = 0

        local movement = {
            xy = start_xy,
            speed_xy = _xy(0, 1),
        }

        function movement.has_reached_target()
            return false
        end

        function movement._update()
            if age >= 40 then
                movement.speed_xy = movement.speed_xy.set_y(3)
            end
            movement.xy = movement.xy.plus(movement.speed_xy)
            age = age + 1
        end

        return movement
    end
end

