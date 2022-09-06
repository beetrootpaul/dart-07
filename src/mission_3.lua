-- -- -- -- -- -- --
-- mission_3.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 3,
    scroll_per_frame = 1.5,
    bg_color = _color_2_darker_purple,
    has_bg_tiles = false,
    mission_name = "rotfl",
    boss_name = "lol"
}

_m.enemy_bullet_factory = new_enemy_bullet_factory {
    bullet_sprite = new_static_sprite(4, 4, 124, 64),
    collision_circle_r = 1.5,
}

function _m.enemy_properties_for(enemy_map_marker)
    if enemy_map_marker == 73 then
        return {
            health = 1,
            ship_sprite = new_static_sprite(8, 8, 0, 64),
            collision_circle_r = 3.5,
            collision_circle_offset_y = 0,
            movement_factory = new_movement_sequence_factory {
                sequence = {
                    new_movement_line_factory {
                        frames = 80,
                        angle = .75,
                        angled_speed = .5,
                    },
                    new_movement_line_factory {
                        angle = .75,
                        angled_speed = 1.5,
                    },
                },
            },
            bullet_fire_timer = new_timer(30),
            spawn_bullets = function(enemy_movement, player_collision_circle)
                local bullets = {}
                for i = 3, 5 do
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .5 + i / 16,
                            angled_speed = 2,
                        }(enemy_movement.xy)
                    ))
                end
                return bullets
            end,
            powerups_distribution = "t",
        }
    end
    assert(false, "unexpected enemy_map_marker = " .. enemy_map_marker)
end

function _m.boss_properties()
    return {
        health = 20,
        sprite = new_static_sprite(56, 26, 4, 98),
        collision_circles = function(movement)
            return {
                { xy = movement.xy.plus(0, 3), r = 5 },
            }
        end,
        phases = {
            -- phase 1:
            {
                triggering_health_fraction = 1,
                bullet_fire_timer = new_timer(80),
                spawn_bullets = function(enemy_movement, player_collision_circle)
                    local bullets = {}
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .75,
                            angled_speed = .5,
                        }(enemy_movement.xy.plus(0, 3))
                    ))
                    return bullets
                end,
                movement_factory = new_movement_fixed_factory(),
            },
        },
    }
end
