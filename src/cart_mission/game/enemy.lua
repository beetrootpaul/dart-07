-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game/enemy.lua   --
-- -- -- -- -- -- -- -- -- -- -- --

do
    local next_id = 0

    function new_enemy(params)
        next_id = next_id + 1

        local enemy_properties = params.enemy_properties
        local start_xy = params.start_xy
        local on_bullets_spawned, on_damaged, on_destroyed = params.on_bullets_spawned, params.on_damaged, params.on_destroyed

        local health = enemy_properties.health
        local movement = enemy_properties.movement_factory(start_xy)
        local bullet_fire_timer = enemy_properties.bullet_fire_timer

        local flashing_after_damage_timer

        local sprite = enemy_properties.ship_sprite

        local is_destroyed = false

        local function collision_circle()
            return {
                xy = movement.xy.plus(0, enemy_properties.collision_circle_offset_y),
                r = enemy_properties.collision_circle_r,
            }
        end

        return {
            id = next_id,

            has_finished = function()
                return is_destroyed or movement.xy.y > _gah + _ts
            end,

            collision_circle = collision_circle,

            take_damage = function(damage)
                health = max(0, health - damage)
                if health > 0 then
                    sprite = enemy_properties.flash_sprite
                    flashing_after_damage_timer = new_timer(4)
                    on_damaged(collision_circle())
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
                    if not _is_collision_circle_nearly_outside_top_edge_of_gameplay_area(collision_circle()) then
                        on_bullets_spawned(enemy_properties.spawn_bullets, movement)
                    end
                end

                if flashing_after_damage_timer then
                    if flashing_after_damage_timer.ttl <= 0 then
                        sprite = enemy_properties.ship_sprite
                        flashing_after_damage_timer = nil
                    else
                        flashing_after_damage_timer._update()
                    end
                end
            end,

            _draw = function()
                sprite._draw(movement.xy)
            end,
        }
    end

end 