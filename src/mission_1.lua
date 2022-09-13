-- -- -- -- -- -- --
-- mission_1.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 1,
    scroll_per_frame = .5,
    mission_name = "death islands",
    boss_name = "painful death",
    bg_color = _color_4_true_blue,
    mission_main_music = 0,
    mission_boss_music = 2,
}

do
    local waves_tile
    local waves_tile_offset_y

    function _m.level_bg_init()
        waves_tile_offset_y = 0
        waves_tile = new_animated_sprite(
            8,
            8,
            split(
                "24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24," ..
                    "32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32," ..
                    "40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40," ..
                    "48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48,48"
            ),
            56,
            { from_left_top_corner = true }
        )
    end

    function _m.level_bg_update()
        waves_tile_offset_y = (waves_tile_offset_y + _m.scroll_per_frame) % _ts
        waves_tile._update()
    end

    function _m.level_bg_draw()
        for distance = 0, 16 do
            for lane = 1, 12 do
                waves_tile._draw(_xy(
                    (lane - 1) * _ts,
                    ceil((distance - 1) * _ts + waves_tile_offset_y)
                ))
            end
        end
    end

    local enemy_bullet_small_factory = new_enemy_bullet_factory {
        bullet_sprite = new_static_sprite(4, 4, 124, 64),
        collision_circle_r = 1.5,
    }
    local enemy_bullet_big_factory = new_enemy_bullet_factory {
        bullet_sprite = new_static_sprite(6, 6, 118, 64),
        collision_circle_r = 2.5,
    }

    function _m.enemy_properties_for(enemy_map_marker)
        return ({

            -- enemy: stationary
            [79] = {
                health = 5,
                ship_sprite = new_static_sprite(22, 24, 0, 64),
                flash_sprite = new_static_sprite(22, 24, 22, 64),
                collision_circle_r = 6,
                movement_factory = new_movement_line_factory {
                    angle = .75,
                    angled_speed = _m.scroll_per_frame,
                    -- DEBUG:
                    --frames = 123,
                },
                bullet_fire_timer = new_timer(60),
                spawn_bullets = function(enemy_movement, player_collision_circle)
                    sfx(32, 3)
                    local bullets = {}
                    for i = 1, 8 do
                        add(bullets, enemy_bullet_small_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = .0625 + i / 8,
                                angled_speed = 1,
                            }(enemy_movement.xy)
                        ))
                    end
                    return bullets
                end,
                powerups_distribution = "h,f,t,s",
            },

            -- TODO: ???
            -- enemy: heavy, aimed spread shot
            --[73] = {
            --    health = 6,
            --    ship_sprite = new_static_sprite(16, 16, 0, 80),
            --    collision_circle_r = 8,
            --    collision_circle_offset_y = 0,
            --    movement_factory = new_movement_line_factory {
            --        angle = .75,
            --        angled_speed = .25,
            --    },
            --    bullet_fire_timer = new_timer(60),
            --    spawn_bullets = function(enemy_movement, player_collision_circle)
            --        local bullets = {}
            --        for i = -2, 2 do
            --            add(bullets, enemy_bullet_small_factory(
            --                new_movement_line_factory {
            --                    angle = i * .04 + _angle_between(enemy_movement.xy, player_collision_circle.xy),
            --                    angled_speed = 1.5,
            --                }(enemy_movement.xy)
            --            ))
            --        end
            --        return bullets
            --    end,
            --    powerups_distribution = "-,h,t",
            --},

            -- TODO: ???
            -- enemy: fast, small
            --[75] = {
            --    health = 1,
            --    ship_sprite = new_static_sprite(7, 7, 14, 73),
            --    collision_circle_r = 3.5,
            --    collision_circle_offset_y = 0,
            --    movement_factory = new_movement_line_factory {
            --        angle = .75,
            --        angled_speed = 1.5,
            --    },
            --    bullet_fire_timer = new_fake_timer(),
            --    spawn_bullets = _noop,
            --    powerups_distribution = "-,h,t",
            --},

            -- TODO: ???
            -- enemy: left-right
            --[76] = {
            --    health = 3,
            --    ship_sprite = new_static_sprite(16, 8, 24, 73),
            --    collision_circle_r = 8,
            --    collision_circle_offset_y = -2,
            --    movement_factory = new_movement_loop_factory({
            --        new_movement_line_factory {
            --            base_speed_y = .25,
            --            frames = 160,
            --            angle = 0,
            --            angled_speed = .5,
            --        },
            --        new_movement_line_factory {
            --            base_speed_y = .25,
            --            frames = 160,
            --            angle = .5,
            --            angled_speed = .5,
            --        },
            --    }),
            --    bullet_fire_timer = new_timer(50),
            --    spawn_bullets = function(enemy_movement, player_collision_circle)
            --        sfx(33, 3)
            --        return {
            --            enemy_bullet_big_factory(
            --                new_movement_line_factory {
            --                    angle = .75,
            --                    angled_speed = .75,
            --                }(enemy_movement.xy)
            --            ),
            --        }
            --    end,
            --    powerups_distribution = "-,h,t",
            --     DEBUG:
            --    powerups_distribution = "s,t,f,h",
            --},

            -- TODO: ???
            -- enemy: sinusoidal
            --[77] = {
            --    health = 1,
            --    ship_sprite = new_static_sprite(6, 7, 26, 64),
            --    collision_circle_r = 3,
            --    collision_circle_offset_y = 0,
            --    movement_factory = new_movement_sinusoidal_factory(),
            --    bullet_fire_timer = new_timer(40),
            --    spawn_bullets = function(enemy_movement, player_collision_circle)
            --        return {
            --            enemy_bullet_small_factory(
            --                new_movement_line_factory({
            --                    base_speed_y = enemy_movement.speed_xy.y,
            --                    angle = .75,
            --                    angled_speed = 1,
            --                })(enemy_movement.xy)
            --            )
            --        }
            --    end,
            --    powerups_distribution = "-,-,-,-,-,-,-,-,-,-,-,-,h,h,h,t",
            -- DEBUG:
            --health = 100,
            --powerups_distribution = "f",
            --powerups_distribution = "h",
            --powerups_distribution = "s,t,f,h",
            --bullet_fire_timer = new_fake_timer(),
            --movement_factory = new_movement_sequence_factory {
            --        new_movement_line_factory {
            --            frames = 160,
            --            angle = .75,
            --            angled_speed = .5,
            --        },
            --        new_movement_fixed_factory(),
            --},
            --},

            -- TODO: ???
            -- enemy: wait and charge
            --[78] = {
            --    health = 3,
            --    ship_sprite = new_static_sprite(12, 9, 14, 64),
            --    collision_circle_r = 6,
            --    collision_circle_offset_y = -1,
            --    movement_factory = new_movement_sequence_factory {
            --        new_movement_line_factory {
            --            frames = 80,
            --            angle = .75,
            --            angled_speed = .5,
            --        },
            --        new_movement_line_factory {
            --            angle = .75,
            --            angled_speed = 1.5,
            --        },
            --    },
            --    bullet_fire_timer = new_fake_timer(),
            --    spawn_bullets = _noop,
            --    powerups_distribution = "-,-,-,-,-,-,-,-,-,h,h,t",
            -- DEBUG:
            --health = 100,
            --powerups_distribution = "t",
            --powerups_distribution = "h",
            --powerups_distribution = "s,t,f,h",
            --bullet_fire_timer = new_fake_timer(),
            --movement_factory = new_movement_sequence_factory {
            --        new_movement_line_factory {
            --            frames = 100,
            --            angle = .75,
            --            angled_speed = .5,
            --        },
            --        new_movement_fixed_factory(),
            --},
            --},

        })[enemy_map_marker]
    end

    function _m.boss_properties()
        return {
            health = 15,
            sprite = new_static_sprite(56, 26, 4, 98),
            collision_circles = function(movement)
                return {
                    { xy = movement.xy.plus(0, 3), r = 5 },
                    { xy = movement.xy.plus(0, -5), r = 7 },
                    { xy = movement.xy.plus(-11, -6), r = 5 },
                    { xy = movement.xy.plus(11, -6), r = 5 },
                    { xy = movement.xy.plus(-21, 3), r = 7 },
                    { xy = movement.xy.plus(21, 3), r = 7 },
                }
            end,
            phases = {
                -- phase 1:
                {
                    triggering_health_fraction = 1,
                    bullet_fire_timer = new_timer(60),
                    spawn_bullets = function(enemy_movement, player_collision_circle)
                        sfx(33, 3)
                        return {
                            enemy_bullet_big_factory(
                                new_movement_line_factory {
                                    base_speed_y = enemy_movement.speed_xy.y,
                                    angle = .75,
                                    angled_speed = 1.5,
                                }(enemy_movement.xy.plus(0, 3))
                            ),
                        }
                    end,
                    movement_factory = new_movement_fixed_factory(),
                },
                -- phase 2:
                {
                    triggering_health_fraction = .85,
                    bullet_fire_timer = new_timer(40),
                    spawn_bullets = function(enemy_movement, player_collision_circle)
                        sfx(33, 3)
                        local bullets = {}
                        add(bullets, enemy_bullet_small_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = _angle_between(enemy_movement.xy.plus(-21, 3), player_collision_circle.xy),
                                angled_speed = 1,
                            }(enemy_movement.xy.plus(-21, 3))
                        ))
                        add(bullets, enemy_bullet_small_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = _angle_between(enemy_movement.xy.plus(21, 3), player_collision_circle.xy),
                                angled_speed = 1,
                            }(enemy_movement.xy.plus(21, 3))
                        ))
                        add(bullets, enemy_bullet_small_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = _angle_between(enemy_movement.xy.plus(0, 3), player_collision_circle.xy),
                                angled_speed = 1,
                            }(enemy_movement.xy.plus(0, 3))
                        ))
                        return bullets
                    end,
                    movement_factory = new_movement_loop_factory({
                        new_movement_to_target_factory {
                            target_x = 30,
                            frames = 60,
                        },
                        new_movement_to_target_factory {
                            target_x = _gaw - 30,
                            frames = 120,
                        },
                        new_movement_to_target_factory {
                            target_x = _gaw / 2,
                            frames = 60,
                        },
                        new_movement_fixed_factory {
                            frames = 120,
                        },
                    }),
                },
                -- phase 3:
                {
                    triggering_health_fraction = .3,
                    bullet_fire_timer = new_timer(60),
                    spawn_bullets = function(enemy_movement, player_collision_circle)
                        sfx(33, 3)
                        local bullets = {}
                        for i = 3, 5 do
                            add(bullets, enemy_bullet_small_factory(
                                new_movement_line_factory {
                                    base_speed_y = enemy_movement.speed_xy.y,
                                    angle = .25 + i / 8,
                                    angled_speed = 1,
                                }(enemy_movement.xy.plus(-21, 3))
                            ))
                            add(bullets, enemy_bullet_small_factory(
                                new_movement_line_factory {
                                    base_speed_y = enemy_movement.speed_xy.y,
                                    angle = .25 + i / 8,
                                    angled_speed = 1,
                                }(enemy_movement.xy.plus(21, 3))
                            ))
                            add(bullets, enemy_bullet_small_factory(
                                new_movement_line_factory {
                                    base_speed_y = enemy_movement.speed_xy.y,
                                    angle = .25 + i / 8,
                                    angled_speed = 1,
                                }(enemy_movement.xy.plus(0, 3))
                            ))
                        end
                        return bullets
                    end,
                    movement_factory = new_movement_sequence_factory {
                        -- center it
                        new_movement_to_target_factory {
                            target_x = _gaw / 2,
                            frames = 40,
                        },
                        -- move to the left
                        new_movement_to_target_factory {
                            target_x = 30,
                            frames = 40,
                        },
                        -- move to the right and to the left in a loop
                        new_movement_loop_factory({
                            new_movement_to_target_factory {
                                target_x = _gaw - 30,
                                frames = 80,
                            },
                            new_movement_to_target_factory {
                                target_x = 30,
                                frames = 80,
                            },
                        }),
                    },
                }
            },
        }
    end

end
