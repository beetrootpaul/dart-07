-- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/sprites/fake_sprite.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_fake_sprite()
    return {
        _update = _noop,
        _draw = _noop,
    }
end
