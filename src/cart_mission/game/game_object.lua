-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/game_object.lua   --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

do
    local next_id = 0

    local prototype = {
        id = next_id,
        to_be_removed = false,
        movement = new_movement_fixed_factory()(_xy_0_0),
        sprite = {
            _draw = _noop,
        },
        collision_circles = function(self)
            return {}
        end,
        _update = function(self)
            self.movement._update()
        end,
        _draw = function(self)
            self.sprite._draw(self.movement.xy)
        end,
    }

    local metatable = {
        __index = prototype,
    }

    new_game_object = setmetatable({}, {
        __call = function(self)
            next_id = next_id + 1
            return setmetatable(
                {
                    id = next_id
                },
                metatable
            )
        end,
    })
end 