-- -- -- -- -- -- --
-- mission_2.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 2,
    scroll_per_frame = 2,
    bg_color = _color_1_dark_blue,
    has_bg_tiles = false,
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
    if enemy_map_marker == 79 then
        return {
            health = 1,
            ship_sprite = new_static_sprite {
                sprite_w = 8,
                sprite_h = 8,
                sprite_x = 0,
                sprite_y = 64,
                transparent_color = _color_11_dark_green,
            },
            collision_circle_r = 4,
            collision_circle_offset_y = 0,
            movement = new_movement_wait_then_charge {
                start_x = start_x,
                start_y = start_y,
            },
            bullet_fire_timer = new_timer(15),
            spawn_bullets = function(movement)
                local bullets = {}
                for i = 3, 5 do
                    add(bullets, new_enemy_bullet {
                        bullet_sprite = _m.bullet_orb.sprite,
                        collision_circle_r = _m.bullet_orb.collision_circle_r,
                        movement = new_movement_angled_line {
                            start_x = movement.x,
                            start_y = movement.y,
                            base_speed_y = movement.speed_y,
                            angle = .5 + i / 16,
                            angled_speed = 4,
                        },
                    })
                end
                return bullets
            end,
            powerups_distribution = "t",
        }
    end
    assert(false, "unexpected enemy_map_marker = " .. enemy_map_marker)
end

function _m.boss_properties(start_x, start_y)
    return {
        health = 20,
        sprite = new_static_sprite {
            sprite_w = 56,
            sprite_h = 26,
            sprite_x = 4,
            sprite_y = 98,
            transparent_color = _color_11_dark_green,
        },
        collision_circles = function(movement)
            return {
                { x = movement.x - .5, y = movement.y - .5 + 3, r = 5 },
            }
        end,
        movement = new_movement_fixed {
            start_x = start_x,
            start_y = start_y,
        },
        bullet_fire_timer = new_timer(20),
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
    }
end
