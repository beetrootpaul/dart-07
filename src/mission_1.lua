-- -- -- -- -- -- --
-- mission_1.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 1,
    scroll_per_frame = 1,
    bg_color = _color_12_true_blue,
    has_bg_tiles = true,
}

_m.enemy_bullet_factory = new_enemy_bullet_factory {
    bullet_sprite = new_static_sprite(4, 4, 124, 64),
    collision_circle_r = 2,
}

function _m.enemy_properties_for(enemy_map_marker)
    if enemy_map_marker == 77 then
        return {
            health = 1,
            ship_sprite = new_static_sprite(6, 7, 26, 64, {
                transparent_color = _color_11_dark_green,
            }),
            collision_circle_r = 3,
            collision_circle_offset_y = 0,
            movement_factory = new_movement_sinusoidal_factory(),
            bullet_fire_timer = new_timer(20),
            spawn_bullets = function(enemy_movement)
                return {
                    _m.enemy_bullet_factory(
                        new_movement_line_factory({
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .75,
                            angled_speed = 2,
                        })(enemy_movement.xy)
                    )
                }
            end,
            powerups_distribution = "t",
        }
    end
    if enemy_map_marker == 78 then
        return {
            health = 3,
            ship_sprite = new_static_sprite(12, 9, 14, 64, {
                transparent_color = _color_11_dark_green,
            }),
            collision_circle_r = 5,
            collision_circle_offset_y = -1,
            movement_factory = new_movement_sequence_factory {
                sequence = {
                    new_movement_line_factory {
                        frames = 40,
                        angle = .75,
                        angled_speed = 1,
                    },
                    new_movement_line_factory {
                        angle = .75,
                        angled_speed = 3,
                    },
                },
            },
            bullet_fire_timer = new_fake_timer(),
            spawn_bullets = _noop,
            powerups_distribution = "-,-,-,-,-,-,-,-,-,a,a,t",
        }
    end
    if enemy_map_marker == 79 then
        return {
            health = 6,
            ship_sprite = new_static_sprite(14, 16, 0, 64, {
                transparent_color = _color_11_dark_green,
            }),
            collision_circle_r = 8,
            collision_circle_offset_y = 0,
            movement_factory = new_movement_stationary_factory(),
            bullet_fire_timer = new_timer(30),
            spawn_bullets = function(enemy_movement)
                local bullets = {}
                for i = 1, 7 do
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .25 + i / 8,
                            angled_speed = 2,
                        }(enemy_movement.xy)
                    ))
                end
                return bullets
            end,
            powerups_distribution = "-,-,-,a,a,t",
        }
    end
    assert(false, "unexpected enemy_map_marker = " .. enemy_map_marker)
end

function _m.boss_properties()
    return {
        health = 50,
        sprite = new_static_sprite(56, 26, 4, 98, {
            transparent_color = _color_11_dark_green,
        }),
        collision_circles = function(movement)
            local adjusted_xy = movement.xy.plus(-.5, -.5)
            return {
                { xy = adjusted_xy.plus(0, 3), r = 5 },
                { xy = adjusted_xy.plus(0, -5), r = 7 },
                { xy = adjusted_xy.plus(-11, -6), r = 5 },
                { xy = adjusted_xy.plus(11, -6), r = 5 },
                { xy = adjusted_xy.plus(-21, 3), r = 7 },
                { xy = adjusted_xy.plus(21, 3), r = 7 },
            }
        end,
        phases = {
            -- phase 1:
            {
                triggering_health_fraction = 1,
                bullet_fire_timer = new_timer(40),
                spawn_bullets = function(enemy_movement)
                    local bullets = {}
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .75 - 1 / 8,
                            angled_speed = 2,
                        }(enemy_movement.xy.plus(0, 3))
                    ))
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .75 + 1 / 8,
                            angled_speed = 2,
                        }(enemy_movement.xy.plus(0, 3))
                    ))
                    return bullets
                end,
                movement_factory = new_movement_fixed_factory(),
            },
            -- phase 2:
            {
                triggering_health_fraction = .85,
                bullet_fire_timer = new_timer(20),
                spawn_bullets = function(enemy_movement)
                    local bullets = {}
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .75,
                            angled_speed = 2,
                        }(enemy_movement.xy.plus(-21, 3))
                    ))
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .75,
                            angled_speed = 2,
                        }(enemy_movement.xy.plus(21, 3))
                    ))
                    add(bullets, _m.enemy_bullet_factory(
                        new_movement_line_factory {
                            base_speed_y = enemy_movement.speed_xy.y,
                            angle = .75,
                            angled_speed = 2,
                        }(enemy_movement.xy.plus(0, 3))
                    ))
                    return bullets
                end,
                movement_factory = new_movement_sequence_factory {
                    loop = true,
                    sequence = {
                        new_movement_to_target_factory {
                            target_x = 30,
                            frames = 30,
                        },
                        new_movement_to_target_factory {
                            target_x = _gaw - 30,
                            frames = 60,
                        },
                        new_movement_to_target_factory {
                            target_x = _gaw / 2,
                            frames = 30,
                        },
                        new_movement_fixed_factory {
                            frames = 60,
                        },
                    },
                },
            },
            -- phase 3:
            {
                triggering_health_fraction = .3,
                bullet_fire_timer = new_timer(30),
                spawn_bullets = function(enemy_movement)
                    local bullets = {}
                    for i = 3, 5 do
                        add(bullets, _m.enemy_bullet_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = .25 + i / 8,
                                angled_speed = 2,
                            }(enemy_movement.xy.plus(-21, 3))
                        ))
                    end
                    for i = 3, 5 do
                        add(bullets, _m.enemy_bullet_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = .25 + i / 8,
                                angled_speed = 2,
                            }(enemy_movement.xy.plus(21, 3))
                        ))
                    end
                    for i = 3, 5 do
                        add(bullets, _m.enemy_bullet_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = .25 + i / 8,
                                angled_speed = 2,
                            }(enemy_movement.xy.plus(0, 3))
                        ))
                    end
                    return bullets
                end,
                movement_factory = new_movement_sequence_factory {
                    sequence = {
                        -- center it
                        new_movement_to_target_factory {
                            target_x = _gaw / 2,
                            frames = 20,
                        },
                        -- move to the left
                        new_movement_to_target_factory {
                            target_x = 30,
                            frames = 20,
                        },
                        -- move to the right and to the left in a loop
                        new_movement_sequence_factory {
                            loop = true,
                            sequence = {
                                new_movement_to_target_factory {
                                    target_x = _gaw - 30,
                                    frames = 40,
                                },
                                new_movement_to_target_factory {
                                    target_x = 30,
                                    frames = 40,
                                },
                            },
                        },
                    },
                },
            }
        },
    }
end
