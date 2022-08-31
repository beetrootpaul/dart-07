-- -- -- -- -- -- -- -- -- -- -- --
-- cart_mission/screen_intro.lua --
-- -- -- -- -- -- -- -- -- -- -- --

-- TODO: polish it

function new_screen_intro()
    local level_descriptor = new_level_descriptor()
    local level = new_level(level_descriptor)
    local player = new_player()

    local hud = new_hud {
        wait_frames = 85,
        slide_in_frames = 20,
    }
    local mission_info = new_mission_info {
        slide_in_frames = 25,
        present_frames = 40,
        slide_out_frames = 25,
    }
    local screen_timer = new_timer(90)

    local health = 5

    --

    local screen = {}

    function screen.init()
        -- TODO: music  
    end

    function screen.update()
        local next_screen = screen

        if screen_timer.ttl <= 1 then
            next_screen = new_screen_mission {
                level = level,
                player = player,
                health = health,
                hud = hud,
            }
        end

        level.scroll()

        player.animate()

        hud.animate()
        mission_info.animate()

        screen_timer.advance()

        return next_screen
    end

    function screen.draw()
        rectfill(_gaox, 0, _gaox + _gaw - 1, _gah - 1, _m.bg_color)
        level.draw {
            draw_within_level_bounds = function()
                player.draw()
            end,
        }

        hud.draw(health)

        mission_info.draw()
    end

    return screen
end
