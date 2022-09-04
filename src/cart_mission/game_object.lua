-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/game_object.lua  --
-- -- -- -- -- -- -- -- -- -- -- --

function _go_update(game_objects)
    for _, game_object in pairs(game_objects) do
        game_object._update()
    end
end

function _go_draw(game_objects)
    for _, game_object in pairs(game_objects) do
        game_object._draw()
    end
end

function _go_draw_debug_collision_circles(game_objects)
    for _, game_object in pairs(game_objects) do
        _collisions._debug_draw_collision_circle(game_object.collision_circle())
    end
end

function _go_delete_finished(game_objects)
    for _, game_object in pairs(game_objects) do
        if game_object.has_finished() then
            del(game_objects, game_object)
        end
    end
end
