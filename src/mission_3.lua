-- -- -- -- -- -- --
-- mission_3.lua  --
-- -- -- -- -- -- --

_m = {
    mission_number = 3,
    scroll_per_frame = 3,
    bg_color = _color_2_darker_purple,
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
        local movement = new_movement_wait_then_charge {
            start_x = start_x,
            start_y = start_y,
        }
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
            movement = movement,
            bullet_fire_timer = new_timer(15),
            spawn_bullets = function()
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
end


