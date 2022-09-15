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
    local tube_tiles = split "71,72,87,88,118,118,118,118,103,104,119,120"
    local tube_tiles_offset_y
    local particles
    local particle_step_counter

    local function maybe_add_particle(y)
        if rnd() < .4 then
            local props = rnd {
                -- particle 1
                { sx = 24, sy = 56, w = 3, h = 4 },
                { sx = 24, sy = 56, w = 3, h = 4 },
                -- particle 2
                { sx = 28, sy = 56, w = 4, h = 3 },
                { sx = 28, sy = 56, w = 4, h = 3 },
                -- particle 3
                { sx = 33, sy = 56, w = 3, h = 3 },
                { sx = 33, sy = 56, w = 3, h = 3 },
                -- particle 4
                { sx = 24, sy = 61, w = 3, h = 3 },
                { sx = 24, sy = 61, w = 3, h = 3 },
                -- particle 5
                { sx = 28, sy = 60, w = 5, h = 4 },
                -- particle 6
                { sx = 34, sy = 60, w = 4, h = 4 },
            }
            add(particles, {
                xy = _xy(
                    flr(4 + rnd(_gaw - 2 * 4)),
                    y
                ),
                sprite = new_static_sprite(props.w, props.h, props.sx, props.sy)
            })
        end
    end

    function _m.level_bg_init()
        tube_tiles_offset_y = 0
        particles = {}
        particle_step_counter = 0

        for y = 0, _gah - 1, _ts do
            maybe_add_particle(y)
        end
    end

    function _m.level_bg_update()
        for particle in all(particles) do
            if particle.xy.y >= _gah + _ts then
                del(particles, particle)
            end
        end

        tube_tiles_offset_y = (tube_tiles_offset_y + .5) % _ts

        for particle in all(particles) do
            particle.xy = particle.xy.plus(0, 1.5)
        end

        particle_step_counter = (particle_step_counter + 1) % 8
        if particle_step_counter == 0 then
            maybe_add_particle(-_ts)
        end
    end

    function _m.level_bg_draw()
        palt(_color_0_black, false)
        palt(_color_11_transparent, true)
        for lane = 1, 12 do
            local tube_tile = tube_tiles[lane]
            for distance = 0, 16 do
                spr(
                    tube_tile,
                    _gaox + (lane - 1) * _ts,
                    ceil((distance - 1) * _ts + tube_tiles_offset_y)
                )
            end
        end
        palt()

        for particle in all(particles) do
            particle.sprite._draw(particle.xy)
        end
    end

    local enemy_bullet_factory = new_enemy_bullet_factory {
        bullet_sprite = new_static_sprite(4, 4, 124, 64),
        collision_circle_r = 1.5,
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

            -- enemy: stationary
            [79] = {
                health = 5,
                sprites_props_txt = "18,16,0,64|18,16,18,64",
                collision_circles_props = {
                    { 5 },
                },
                movement_factory = new_movement_line_factory {
                    angle = .75,
                    angled_speed = _m.scroll_per_frame,
                    -- DEBUG:
                    --frames = 89,
                },
                bullet_fire_timer = new_timer(40),
                spawn_bullets = function(enemy_movement, player_collision_circle)
                    _sfx_play(32)
                    local bullets = {}
                    for i = 1, 8 do
                        add(bullets, enemy_bullet_factory(
                            new_movement_line_factory {
                                base_speed_y = enemy_movement.speed_xy.y,
                                angle = .0625 + i / 8,
                            }(enemy_movement.xy)
                        ))
                    end
                    return bullets
                end,
                powerups_distribution = "h,f,t,s",
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
            health = 25,
            -- TODO: draw and specify correct flash sprite
            sprites_props_txt = "56,26,4,98|56,26,4,98",
            collision_circles_props = {
                { 15, _xy(0, 3) },
            },
            phases = {
                -- phase 1:
                {
                    triggering_health_fraction = 1,
                    bullet_fire_timer = new_timer(80),
                    spawn_bullets = function(enemy_movement, player_collision_circle)
                        _sfx_play(32)
                        return {
                            enemy_bullet_factory(
                                new_movement_line_factory {
                                    base_speed_y = enemy_movement.speed_xy.y,
                                    angle = .75,
                                    angled_speed = .5,
                                }(enemy_movement.xy.plus(0, 3))
                            ),
                        }
                    end,
                    movement_factory = new_movement_fixed_factory(),
                },
            },
        }
    end

end
