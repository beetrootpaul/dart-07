-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- common/movement/movement_loop_factory.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_movement_loop_factory(sequence)
    return new_movement_sequence_factory(sequence, true)
end

