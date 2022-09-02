-- -- -- -- -- -- --
-- mission_1.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 1,
    scroll_per_frame = 1,
    bg_color = _color_12_true_blue,
    has_bg_tiles = true,
}

_m.bullet_orb = {
    sprite = new_static_sprite(4, 4, 124, 64),
    collision_circle_r = 2,
}

function _m.enemy_properties_for(enemy_map_marker, start_x, start_y)
    if enemy_map_marker == 77 then
        return {
            health = 1,
            ship_sprite = new_static_sprite(6, 7, 26, 64, {
                transparent_color = _color_11_dark_green,
            }),
            collision_circle_r = 3,
            collision_circle_offset_y = 0,
            movement = new_movement_sinusoidal {
                start_x = start_x,
                start_y = start_y,
            },
            bullet_fire_timer = new_timer(20),
            spawn_bullets = function(movement)
                return {
                    new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x,
                            start_y = movement.y,
                            base_speed_y = movement.speed_y,
                            angle = .75,
                            angled_speed = 2,
                        },
                    }
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
            movement = new_movement_wait_then_charge {
                start_x = start_x,
                start_y = start_y,
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
            movement = new_movement_stationary {
                start_x = start_x,
                start_y = start_y,
            },
            bullet_fire_timer = new_timer(30),
            spawn_bullets = function(movement)
                local bullets = {}
                for i = 1, 7 do
                    add(bullets, new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x,
                            start_y = movement.y,
                            base_speed_y = movement.speed_y,
                            angle = .25 + i / 8,
                            angled_speed = 2,
                        },
                    })
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
            local adjusted_x = movement.x - .5
            local adjusted_y = movement.y - .5
            return {
                { x = adjusted_x, y = adjusted_y + 3, r = 5 },
                { x = adjusted_x, y = adjusted_y - 5, r = 7 },
                { x = adjusted_x - 11, y = adjusted_y - 6, r = 5 },
                { x = adjusted_x + 11, y = adjusted_y - 6, r = 5 },
                { x = adjusted_x - 21, y = adjusted_y + 3, r = 7 },
                { x = adjusted_x + 21, y = adjusted_y + 3, r = 7 },
            }
        end,
        phases = {
            -- phase 1:
            {
                triggering_health_fraction = 1,
                bullet_fire_timer = new_timer(40),
                spawn_bullets = function(movement)
                    local bullets = {}
                    add(bullets, new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x,
                            start_y = movement.y + 3,
                            base_speed_y = movement.speed_y,
                            angle = .75 - 1 / 8,
                            angled_speed = 2,
                        },
                    })
                    add(bullets, new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x,
                            start_y = movement.y + 3,
                            base_speed_y = movement.speed_y,
                            angle = .75 + 1 / 8,
                            angled_speed = 2,
                        },
                    })
                    return bullets
                end,
                -- TODO: refactor movements so they return a function which requires start_xy then inside boss file, not here
                movement_cycle = {
                    function(movement)
                        return new_movement_fixed {
                            start_x = movement.x,
                            start_y = movement.y,
                        }
                    end,
                },
            },
            -- phase 2:
            {
                triggering_health_fraction = .7,
                bullet_fire_timer = new_timer(20),
                spawn_bullets = function(movement)
                    local bullets = {}
                    add(bullets, new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x - 21,
                            start_y = movement.y + 3,
                            base_speed_y = movement.speed_y,
                            angle = .75,
                            angled_speed = 2,
                        },
                    })
                    add(bullets, new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x + 21,
                            start_y = movement.y + 3,
                            base_speed_y = movement.speed_y,
                            angle = .75,
                            angled_speed = 2,
                        },
                    })
                    add(bullets, new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x,
                            start_y = movement.y + 3,
                            base_speed_y = movement.speed_y,
                            angle = .75,
                            angled_speed = 2,
                        },
                    })
                    return bullets
                end,
                -- TODO: refactor movements so they return a function which requires start_xy then inside boss file, not here
                movement_cycle = {
                    function(movement)
                        return new_movement_fixed {
                            start_x = movement.x,
                            start_y = movement.y,
                            frames = 90,
                        }
                    end,
                    function(movement)
                        return {
                            movement = new_movement_to_target {
                                start_x = movement.x,
                                start_y = movement.y,
                                target_x = _gaox + 30,
                                target_y = movement.y,
                                frames = 30,
                            },
                        }
                    end,
                    function(movement)
                        return {
                            movement = new_movement_to_target {
                                start_x = movement.x,
                                start_y = movement.y,
                                target_x = _gaox + _gaw - 30,
                                target_y = movement.y,
                                frames = 60,
                            },
                        }
                    end,
                    function(movement)
                        return {
                            movement = new_movement_to_target {
                                start_x = movement.x,
                                start_y = movement.y,
                                target_x = _gaox + _gaw / 2,
                                target_y = movement.y,
                                frames = 30,
                            },
                        }
                    end,
                },
            },
            -- phase 3:
            {
                triggering_health_fraction = .3,
                bullet_fire_timer = new_timer(30),
                spawn_bullets = function(movement)
                    local bullets = {}
                    for i = 3, 5 do
                        add(bullets, new_enemy_bullet {
                            bullet_sprite = _m.bullet_orb.sprite,
                            collision_circle_r = _m.bullet_orb.collision_circle_r,
                            movement = new_movement_angled_line {
                                start_x = movement.x - 21,
                                start_y = movement.y + 3,
                                base_speed_y = movement.speed_y,
                                angle = .25 + i / 8,
                                angled_speed = 2,
                            },
                        })
                    end
                    for i = 3, 5 do
                        add(bullets, new_enemy_bullet {
                            bullet_sprite = _m.bullet_orb.sprite,
                            collision_circle_r = _m.bullet_orb.collision_circle_r,
                            movement = new_movement_angled_line {
                                start_x = movement.x + 21,
                                start_y = movement.y + 3,
                                base_speed_y = movement.speed_y,
                                angle = .25 + i / 8,
                                angled_speed = 2,
                            },
                        })
                    end
                    for i = 3, 5 do
                        add(bullets, new_enemy_bullet {
                            bullet_sprite = _m.bullet_orb.sprite,
                            collision_circle_r = _m.bullet_orb.collision_circle_r,
                            movement = new_movement_angled_line {
                                start_x = movement.x,
                                start_y = movement.y + 3,
                                base_speed_y = movement.speed_y,
                                angle = .25 + i / 8,
                                angled_speed = 2,
                            },
                        })
                    end
                    return bullets
                end,
                movement_cycle = {
                    function(movement)
                        return new_movement_fixed {
                            start_x = movement.x,
                            start_y = movement.y,
                            frames = 40,
                        }
                    end,
                    function(movement)
                        return {
                            movement = new_movement_to_target {
                                start_x = movement.x,
                                start_y = movement.y,
                                target_x = _gaox + 30,
                                target_y = movement.y,
                                frames = 30,
                            },
                        }
                    end,
                    function(movement)
                        return {
                            movement = new_movement_to_target {
                                start_x = movement.x,
                                start_y = movement.y,
                                target_x = _gaox + _gaw - 30,
                                target_y = movement.y,
                                frames = 60,
                            },
                        }
                    end,
                    function(movement)
                        return {
                            movement = new_movement_to_target {
                                start_x = movement.x,
                                start_y = movement.y,
                                target_x = _gaox + _gaw / 2,
                                target_y = movement.y,
                                frames = 30,
                            },
                        }
                    end,
                },
            }
        },
    }
end
