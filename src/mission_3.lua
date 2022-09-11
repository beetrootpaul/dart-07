-- -- -- -- -- -- --
-- mission_3.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 3,
    scroll_per_frame = 1,
    mission_name = "rotfl",
    boss_name = "lol",
    bg_color = _color_2_darker_purple,
    mission_main_music = 0,
    mission_boss_music = 1,
}

do
    local particles

    local function maybe_add_particle(y)
        if rnd() < .1 then
            local props = rnd {
                { sx = 24, sy = 56, w = 5, h = 5 },
                { sx = 29, sy = 56, w = 4, h = 3 },
                { sx = 29, sy = 59, w = 3, h = 4 },
            }
            add(particles, {
                xy = _xy(
                    ceil(.1 + rnd(_gaw - .1)),
                    y
                ),
                sprite = new_static_sprite(props.w, props.h, props.sx, props.sy)
            })
        end
    end

    function _m.level_bg_init()
        particles = {}

        for y = 0, _gah - 1 do
            maybe_add_particle(y)
        end
    end

    function _m.level_bg_update()
        for _, particle in pairs(particles) do
            particle.xy = particle.xy.plus(0, _m.scroll_per_frame)
            if particle.xy.y >= _gah + _ts then
                del(particles, particle)
            end
        end

        maybe_add_particle(-_ts)
    end

    function _m.level_bg_draw(min_visible_distance, max_visible_distance)
        for _, particle in pairs(particles) do
            particle.sprite._draw(particle.xy)
        end
    end

    local enemy_bullet_factory = new_enemy_bullet_factory {
        bullet_sprite = new_static_sprite(4, 4, 124, 64),
        collision_circle_r = 1.5,
    }

    function _m.enemy_properties_for(enemy_map_marker)
        return ({

            [73] = {
                health = 1,
                ship_sprite = new_static_sprite(8, 8, 0, 64),
                collision_circle_r = 3.5,
                collision_circle_offset_y = 0,
                movement_factory = new_movement_sequence_factory {
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
                bullet_fire_timer = new_timer(30),
                spawn_bullets = function(enemy_movement, player_collision_circle)
                    sfx(32, 3)
                    local bullets = {}
                    for i = 4, 4 do
                        add(bullets, enemy_bullet_factory(
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
            },

        })[enemy_map_marker]
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
                        sfx(32, 3)
                        local bullets = {}
                        add(bullets, enemy_bullet_factory(
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

end
