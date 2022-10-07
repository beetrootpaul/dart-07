-- -- -- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/player_bullet.lua --
-- -- -- -- -- -- -- -- -- -- -- -- -- --

function new_player_bullet(start_xy)
    return setmetatable(
        {
            movement = new_movement_line_factory {
                angle = .25,
                angled_speed = 2.5,
                -- DEBUG:
                --angled_speed = .5,
                --frames = 10,
            }(start_xy),
            sprite = new_static_sprite "4,5,9,11",
            collision_circles = function(self)
                return {
                    { xy = self.movement.xy.minus(0, .5), r = 1.5 },
                }
            end,
            _update = function(self)
                self.movement._update()
                self.to_be_removed = self.to_be_removed or _is_safely_outside_gameplay_area(self.movement.xy)
            end,
        },
        { __index = new_game_object() }
    )
end

