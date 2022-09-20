-- -- -- -- -- -- -- --
-- common/audio.lua  --
-- -- -- -- -- -- -- --

-- SFXs shared between carts: 0 - 31
-- music and SFX individual for a cart: 32 - 64

_sfx_options_change = 0
--_sfx_options_prev = 1
_sfx_options_confirm = 2
--_sfx_options_cannot_confirm = 3

-- _sfx_powerup_spawned = 4
_sfx_powerup_no_effect, _sfx_powerup_picked = 5, 6
-- _sfx_powerup_heart = 6
-- _sfx_powerup_triple_shoot = 7
-- _sfx_powerup_fast_shoot = 8
-- _sfx_powerup_shockwave = 9

_sfx_player_shoot, _sfx_player_triple_shoot, _sfx_player_shockwave, _sfx_enemy_shoot, _sfx_enemy_multi_shoot = 10, 11, 12, 13, 14
-- unused yet: 15

_sfx_damage_player, _sfx_damage_enemy = 16, 17
-- _sfx_damage_boss = 18

_sfx_destroy_player, _sfx_destroy_enemy, _sfx_destroy_boss_phase, _sfx_destroy_boss_final_1, _sfx_destroy_boss_final_2, _sfx_destroy_boss_final_3 = 19, 20, 21, 22, 23, 24

-- channels in music tracks of this game:
--  - 0 = percussion
--  - 1 = main
--  - 2 = bass line
--  - 3 = extra melody
function _sfx_play(sfx_id, non_zero_channel)
    sfx(sfx_id, non_zero_channel or 0)
end

function _music_fade_out()
    music(-1, 500)
end