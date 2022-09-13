-- -- -- -- -- -- --
-- mission_2.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 2,
    scroll_per_frame = 1,
    mission_name = "death space",
    boss_name = "cheerful death",
    bg_color = _color_1_darker_blue,
    mission_main_music = 0,
    mission_boss_music = 1,
}

do
    local stars

    local function maybe_add_star(y)
        if rnd() < .1 then
            local star = {
                x = ceil(1 + rnd(_gaw - 3)),
                y = y,
                speed = rnd { .25, .5, .75 }
            }
            star.color = star.speed == .75 and _color_6_light_grey or (star.speed == .5 and _color_13_lavender or _color_14_mauve)
            add(stars, star)
        end
    end

    function _m.level_bg_init()
        stars = {}

        for y = 0, _gah - 1 do
            maybe_add_star(y)
        end
    end

    function _m.level_bg_update()
        for _, star in pairs(stars) do
            star.y = star.y + star.speed
            if star.y >= _gah then
                del(stars, star)
            end
        end

        maybe_add_star(0)
    end

    function _m.level_bg_draw()
        for _, star in pairs(stars) do
            pset(
                _gaox + star.x,
                star.y,
                star.color
            )
        end
    end

    local enemy_bullet_factory = new_enemy_bullet_factory {
        bullet_sprite = new_static_sprite(4, 4, 124, 64),
        collision_circle_r = 1.5,
    }

    function _m.enemy_properties_for(enemy_map_marker)
        return ({

            [79] = {
                health = 1,
                ship_sprite = new_static_sprite(8, 8, 0, 64),
                flash_sprite = new_static_sprite(8, 8, 0, 64),
                collision_circle_r = 3.5,
                collision_circle_offset_y = 0,
                movement_factory = new_movement_sequence_factory {
                    new_movement_line_factory {
                        angle = .75,
                        angled_speed = _m.scroll_per_frame,
                    },
                    --new_movement_line_factory {
                    --    frames = 80,
                    --    angle = .75,
                    --    angled_speed = .5,
                    --},
                    --new_movement_line_factory {
                    --    angle = .75,
                    --    angled_speed = 1.5,
                    --},
                },
                bullet_fire_timer = new_timer(60),
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
            health = 25,
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
