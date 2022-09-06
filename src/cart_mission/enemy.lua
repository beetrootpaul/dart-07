-- -- -- -- -- -- -- -- -- --
-- cart_mission/enemy.lua  --
-- -- -- -- -- -- -- -- -- --

function new_enemy(params)
    local enemy_properties = params.enemy_properties
    local start_xy = params.start_xy
    local on_bullets_spawned = params.on_bullets_spawned
    local on_destroyed = params.on_destroyed

    local health = enemy_properties.health
    local movement = enemy_properties.movement_factory(start_xy)
    local bullet_fire_timer = enemy_properties.bullet_fire_timer

    local is_flashing_from_damage = false
    local is_destroyed = false

    local function collision_circle()
        return {
            xy = movement.xy.plus(0, enemy_properties.collision_circle_offset_y),
            r = enemy_properties.collision_circle_r,
        }
    end

    return {
        has_finished = function()
            return is_destroyed or movement.xy.y > _gah + _ts
        end,

        collision_circle = collision_circle,

        take_damage = function()
            health = health - 1
            if health > 0 then
                is_flashing_from_damage = true
            else
                is_destroyed = true
                local powerup_type = rnd(split(enemy_properties.powerups_distribution))
                on_destroyed(collision_circle(), powerup_type)
            end
        end,

        _update = function()
            movement._update()

            bullet_fire_timer._update()
            if bullet_fire_timer.ttl <= 0 then
                bullet_fire_timer.restart()
                local cc = collision_circle()
                if not _is_y_not_within_gameplay_area(cc.xy.y + cc.r) then
                    on_bullets_spawned(enemy_properties.spawn_bullets, movement)
                end
            end

            is_flashing_from_damage = false
        end,

        _draw = function()
            enemy_properties.ship_sprite._draw(movement.xy, {
                -- TODO: make it pure white?
                flash_color = is_flashing_from_damage and _color_9_dark_orange or nil,
            })
        end,
    }
end