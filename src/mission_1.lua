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
    sprite = new_static_sprite {
        sprite_w = 4,
        sprite_h = 4,
        sprite_x = 124,
        sprite_y = 64,
    },
    collision_circle_r = 2,
}

function _m.enemy_properties_for(enemy_map_marker, start_x, start_y)
    if enemy_map_marker == 77 then
        local movement = new_movement_sinusoidal {
            start_x = start_x,
            start_y = start_y,
        }
        return {
            health = 1,
            ship_sprite = new_static_sprite {
                sprite_w = 6,
                sprite_h = 7,
                sprite_x = 26,
                sprite_y = 64,
                transparent_color = _color_11_dark_green,
            },
            collision_circle_r = 3,
            collision_circle_offset_y = 0,
            movement = movement,
            bullet_fire_timer = new_timer(20),
            spawn_bullets = function()
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
            powerups_distribution = "-,-,-,-,-,-,-,-,-,-,-,-,-,-,a,a,t",
        }
    end
    if enemy_map_marker == 78 then
        local movement = new_movement_wait_then_charge {
            start_x = start_x,
            start_y = start_y,
        }
        return {
            health = 3,
            ship_sprite = new_static_sprite {
                sprite_w = 12,
                sprite_h = 9,
                sprite_x = 14,
                sprite_y = 64,
                transparent_color = _color_11_dark_green,
            },
            collision_circle_r = 5,
            collision_circle_offset_y = -1,
            movement = movement,
            bullet_fire_timer = new_fake_timer(),
            spawn_bullets = function()
                return {}
            end,
            powerups_distribution = "-,-,-,-,-,-,-,-,-,a,a,t",
        }
    end
    if enemy_map_marker == 79 then
        local movement = new_movement_stationary {
            start_x = start_x,
            start_y = start_y,
        }
        return {
            health = 6,
            ship_sprite = new_static_sprite {
                sprite_w = 14,
                sprite_h = 16,
                sprite_x = 0,
                sprite_y = 64,
                transparent_color = _color_11_dark_green,
            },
            collision_circle_r = 8,
            collision_circle_offset_y = 0,
            movement = movement,
            bullet_fire_timer = new_timer(30),
            spawn_bullets = function()
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
    local movement = new_movement_fixed {
        start_x = _gaox + _gaw / 2,
        start_y = 20,
    }
    return {
        health = 20,
        sprite = new_static_sprite {
            sprite_w = 56,
            sprite_h = 26,
            sprite_x = 4,
            sprite_y = 98,
            transparent_color = _color_11_dark_green,
        },
        collision_circle_r = 30,
        collision_circle_offset_y = 3,
        movement = movement,
        bullet_fire_timer = new_timer(20),
        spawn_bullets = function()
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
    }
end
