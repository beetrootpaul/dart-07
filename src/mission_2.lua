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
        for star in all(stars) do
            star.y = star.y + star.speed
            if star.y >= _gah then
                del(stars, star)
            end
        end

        maybe_add_star(0)
    end

    function _m.level_bg_draw()
        for star in all(stars) do
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
                sprites_props_txt = "28,28,0,64|28,28,28,64",
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
                     _sfx_play(_sfx_enemy_multi_shoot)
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

            -- TODO: ???
            -- enemy: left-right
            --[76] = {
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
            --},

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
                         _sfx_play(_sfx_enemy_multi_shoot)
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
