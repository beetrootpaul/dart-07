-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- common/movement/movement_sequence_factory.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function new_movement_sequence_factory(sequence, loop)
    return function(start_xy)
        local sequence_index = 1
        local current_sub_movement = sequence[sequence_index](start_xy)
        local movement = {
            xy = current_sub_movement.xy,
            speed_xy = current_sub_movement.speed_xy
        }
        function movement.has_finished()
            if loop then
                return false
            end
            return sequence_index >= #sequence and current_sub_movement.has_finished()
        end
        
        function movement._update()
            current_sub_movement._update()
            if current_sub_movement.has_finished() then
                if sequence_index < #sequence then
                    sequence_index = sequence_index + 1
                    current_sub_movement = sequence[sequence_index](current_sub_movement.xy)
                elseif loop then
                    sequence_index = 1
                    current_sub_movement = sequence[sequence_index](current_sub_movement.xy)
                end
            end
            movement.xy, movement.speed_xy = current_sub_movement.xy, current_sub_movement.speed_xy
        end
        
        return movement
    end
end
