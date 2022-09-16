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

    -- enemy property:
    --   - sprites_props_txt = "w,h,x,y|w,h,x,y" -- where 1st set is for a ship sprite, and 2nd – for a damage flash overlay
    --   - collision_circles_props = {
    --                    { r, optional_xy_offset }, -- put main/center circle first, since it will be source for explosions etc.
    --                    { r, optional_xy_offset },
    --                    { r },
    --                },
    --   - spawn_bullets = function(enemy_movement, player_collision_circle)
    --                       return bullets_table
    --                     end
    function _m.enemy_properties_for(enemy_map_marker)
        return ({

            -- enemy: fast and small
            [74] = {
                health = 1,
                sprites_props_txt = "8,8,0,88|6,6,22,79",
                collision_circles_props = {
                    { 3, _xy(0, 1) },
                },
                movement_factory = new_movement_line_factory {
                    angle = .75,
                    angled_speed = 1.5,
                    -- DEBUG:
                    --frames = 123,
                },
                powerups_distribution = "-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,h,f,f,f,t,t,s",
            },

            -- enemy: sinusoidal
            [75] = {
                health = 2,
                sprites_props_txt = "10,10,22,86 |8,8,13,88",
                collision_circles_props = {
                    { 4 },
                },
                movement_factory = new_movement_sinusoidal_factory {
                    speed_y = .75,
                },
                -- DEBUG:
                --movement_factory = new_movement_line_factory {
                --    angle = .75,
                --    angled_speed = _m.scroll_per_frame,
                --    frames = 234,
                --},
                bullet_fire_timer = new_timer(40),
                spawn_bullets = function(enemy_movement)
                    _sfx_play(_sfx_enemy_shoot)
                    return {
                        enemy_bullet_small_factory(
                            new_movement_line_factory({
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = .75,
                            })(enemy_movement.xy)
                        )
                    }
                end,
                powerups_distribution = "-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,-,h,f,f,f,t,t,s",
            },

            -- enemy: wait and charge
            [76] = {
                health = 7,
                sprites_props_txt = "16,14,22,64|14,12,32,84",
                collision_circles_props = {
                    { 7 },
                },
                movement_factory = new_movement_sequence_factory {
                    new_movement_line_factory {
                        frames = 80,
                        angle = .75,
                        angled_speed = .5,
                    },
                    new_movement_line_factory {
                        angle = .75,
                    },
                },
                -- DEBUG:
                --movement_factory = new_movement_line_factory {
                --    angle = .75,
                --    angled_speed = _m.scroll_per_frame,
                --    frames = 234,
                --},
                powerups_distribution = "-,-,-,-,-,-,-,-,-,-,h,h,f,t,s,s",
            },

            -- enemy: big
            [77] = {
                health = 30,
                sprites_props_txt = "24,20,64,64|22,18,88,65",
                collision_circles_props = {
                    { 10, _xy(0, 1) },
                    { 5, _xy(-7, 0) },
                    { 5, _xy(7, 0) },
                    { 5, _xy(0, -4) },
                },
                movement_factory = new_movement_sequence_factory {
                    new_movement_to_target_factory {
                        target_y = 32,
                        frames = 120,
                        easing_fn = _easing_easeoutquart,
                    },
                    new_movement_fixed_factory {
                        target_y = 32,
                        frames = 480,
                    },
                    new_movement_to_target_factory {
                        target_y = 140,
                        frames = 120,
                        easing_fn = _easing_easeinquart,
                    },
                },
                -- DEBUG:
                --movement_factory = new_movement_line_factory {
                --    angle = .75,
                --    angled_speed = _m.scroll_per_frame,
                --    frames = 123,
                --},
                bullet_fire_timer = new_timer(40),
                spawn_bullets = function(enemy_movement)
                     _sfx_play(_sfx_enemy_multi_shoot)
                    local bullets = {}
                    for i = 1, 8 do
                        add(bullets, enemy_bullet_small_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = t() % 1 + i / 8,
                            }(enemy_movement.xy)
                        ))
                    end
                    return bullets
                end,
                powerups_distribution = "h,s",
            },

            -- enemy: long, pausing, w/ aimed triple shot
            [78] = {
                health = 4,
                sprites_props_txt = "8,22,50,64|6,20,58,65",
                collision_circles_props = {
                    { 4 },
                    { 4, _xy(0, 7) },
                    { 4, _xy(0, -7) },
                },
                movement_factory = new_movement_sequence_factory({
                    new_movement_to_target_factory {
                        target_y = 80,
                        frames = 150,
                        easing_fn = _easing_easeoutquad,
                    },
                    new_movement_to_target_factory {
                        target_y = 30,
                        frames = 80,
                    },
                    new_movement_to_target_factory {
                        target_y = 160,
                        frames = 150,
                        easing_fn = _easing_easeinquad,
                    },
                }),
                -- DEBUG:
                --movement_factory = new_movement_line_factory {
                --    angle = .75,
                --    angled_speed = _m.scroll_per_frame,
                --    frames = 160,
                --},
                bullet_fire_timer = new_timer(60),
                spawn_bullets = function(enemy_movement, player_collision_circle)
                     _sfx_play(_sfx_enemy_multi_shoot)
                    local enemy_xy = enemy_movement.xy
                    local player_xy = player_collision_circle.xy
                    return {
                        enemy_bullet_small_factory(
                            new_movement_line_factory {
                                target_xy = player_xy,
                            }(enemy_xy.minus(0, 7))
                        ),
                        enemy_bullet_small_factory(
                            new_movement_line_factory {
                                target_xy = player_xy,
                            }(enemy_xy.minus(0, 1))
                        ),
                        enemy_bullet_small_factory(
                            new_movement_line_factory {
                                target_xy = player_xy,
                            }(enemy_xy.plus(0, 5))
                        ),
                    }
                end,
                powerups_distribution = "-,-,-,-,-,-,h,f,f,f,t,t,s",
            },

            -- enemy: stationary
            [79] = {
                health = 10,
                sprites_props_txt = "22,24,0,64|12,12,38,64",
                collision_circles_props = {
                    { 6 },
                },
                movement_factory = new_movement_line_factory {
                    angle = .75,
                    angled_speed = _m.scroll_per_frame,
                    -- DEBUG:
                    --frames = 100,
                },
                bullet_fire_timer = new_timer(60),
                spawn_bullets = function(enemy_movement)
                     _sfx_play(_sfx_enemy_multi_shoot)
                    local bullets = {}
                    for i = 1, 8 do
                        add(bullets, enemy_bullet_small_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = .0625 + i / 8,
                            }(enemy_movement.xy)
                        ))
                    end
                    return bullets
                end,
                powerups_distribution = "-,-,h,h,t,s,s,s",
            },

        })[enemy_map_marker]
    end

    -- boss property:
    --   - sprites_props_txt = "w,h,x,y|w,h,x,y" -- where 1st set is for a ship sprite, and 2nd – for a damage flash overlay
    --   - collision_circles_props = {
    --                    { r, optional_xy_offset }, -- put main/center circle first, since it will be source for explosions etc.
    --                    { r, optional_xy_offset },
    --                    { r },
    --                },
    --   - spawn_bullets = function(boss_movement, player_collision_circle)
    --                       return bullets_table
    --                     end
    function _m.boss_properties()
        return {
            health = 50,
            sprites_props_txt = "54,20,0,96|52,18,54,97",
            collision_circles_props = {
                { 11 },
                { 6, _xy(20, -3) },
                { 6, _xy(-20, -3) },
            },
            phases = {
                -- phase 1:
                {
                    triggering_health_fraction = 1,
                    bullet_fire_timer = new_timer(8),
                    spawn_bullets = function(boss_movement)
                        if t() % 2 < 1 then return {} end
                        _sfx_play(_sfx_enemy_shoot)
                        return {
                            enemy_bullet_small_factory(
                                new_movement_line_factory {
                                    angle = .75,
                                    angled_speed = 1.5,
                                }(boss_movement.xy.plus(0, 3))
                            ),
                        }
                    end,
                    movement_factory = new_movement_fixed_factory(),
                },
                -- phase 2:
                {
                    triggering_health_fraction = .85,
                    bullet_fire_timer = new_timer(8),
                    spawn_bullets = function(boss_movement)
                        if t() % 2 < 1 then return {} end
                        _sfx_play(_sfx_enemy_shoot)
                        return {
                            enemy_bullet_small_factory(
                                new_movement_line_factory {
                                    angle = .75,
                                    angled_speed = 1.5,
                                }(boss_movement.xy.plus(0, 3))
                            ),
                        }
                    end,
                    movement_factory = new_movement_sequence_factory {
                        new_movement_to_target_factory {
                            target_x = 30,
                            frames = 40,
                            easing_fn = _easing_easeoutquad,
                        },
                        new_movement_loop_factory {
                            new_movement_to_target_factory {
                                target_x = _gaw - 30,
                                frames = 80,
                                easing_fn = _easing_easeoutquad,
                            },
                            new_movement_to_target_factory {
                                target_x = 30,
                                frames = 80,
                                easing_fn = _easing_easeoutquad,
                            },
                        },
                    },
                },
                -- phase 3:
                {
                    triggering_health_fraction = .35,
                    bullet_fire_timer = new_timer(8),
                    spawn_bullets = function(boss_movement, player_collision_circle)
                         _sfx_play(_sfx_enemy_multi_shoot)
                        if t() % 2 > 1.3 and t() % 2 < 1.6 then
                            -- aimed side bullets
                            return {
                                enemy_bullet_small_factory(
                                    new_movement_line_factory {
                                        target_xy = player_collision_circle.xy,
                                    }(boss_movement.xy.plus(-20, -3))
                                ),
                                enemy_bullet_small_factory(
                                    new_movement_line_factory {
                                        target_xy = player_collision_circle.xy,
                                    }(boss_movement.xy.plus(20, -3))
                                ),
                            }
                        elseif t() % 2 < 1 then
                            -- sinusoidal central bullets
                            return {
                                enemy_bullet_small_factory(
                                    new_movement_sinusoidal_factory {
                                        speed_y = 1.5,
                                        age_divisor = 60,
                                    }(boss_movement.xy.plus(0, 3))
                                ),
                            }
                        end
                    end,
                    movement_factory = new_movement_loop_factory {
                        -- center it
                        new_movement_to_target_factory {
                            target_x = _gaw / 2,
                            target_y = 20,
                            frames = 60,
                            easing_fn = _easing_easeoutquad,
                        },
                        -- wait …
                        new_movement_fixed_factory {
                            frames = 100,
                        },
                        -- … and charge!
                        new_movement_to_target_factory {
                            target_y = _gah - 20,
                            frames = 40,
                            easing_fn = _easing_easeinquad,
                        },
                        -- then revert
                        new_movement_to_target_factory {
                            target_y = 20,
                            frames = 120,
                            easing_fn = _easing_linear(),
                        },
                        -- wait again a little bit
                        new_movement_fixed_factory {
                            frames = 50,
                        },
                        -- go left and right
                        new_movement_to_target_factory {
                            target_x = _gaw - 30,
                            frames = 80,
                            easing_fn = _easing_easeoutquad,
                        },
                        new_movement_to_target_factory {
                            target_x = 30,
                            frames = 80,
                            easing_fn = _easing_easeoutquad,
                        },
                    },
                }
            },
        }
    end

end
