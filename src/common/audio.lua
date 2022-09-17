-- -- -- -- -- -- -- --
-- common/audio.lua  --
-- -- -- -- -- -- -- --

-- SFXs shared between carts: 0 - 31
-- music and SFX individual for a cart: 32 - 64

_sfx_options_change = 0
--_sfx_options_prev = 1
_sfx_options_confirm = 2
--_sfx_options_cannot_confirm = 3

_sfx_powerup_spawned, _sfx_powerup_no_effect, _sfx_powerup_heart, _sfx_powerup_triple_shot, _sfx_powerup_fast_shot, _sfx_powerup_shockwave = 4, 5, 6, 7, 8, 9

_sfx_player_shoot, _sfx_player_triple_shoot, _sfx_player_shockwave, _sfx_enemy_shoot, _sfx_enemy_multi_shoot = 10, 11, 12, 13, 14
-- unused yet: 15

_sfx_damage_player, _sfx_damage_enemy, _sfx_damage_boss = 16, 17, 18

_sfx_destroy_player, _sfx_destroy_enemy, _sfx_destroy_boss_phase, _sfx_destroy_boss_final_1, _sfx_destroy_boss_final_2, _sfx_destroy_boss_final_3 = 19, 20, 21, 22, 23, 24

-- 1) use channel 3 for very frequent sfx like player shooting, and try to not put any music there
-- 2) use channel 0 for all other sfxs and keep music percussion there as well, so it will be least disturbing
function _sfx_play(sfx_id, player_shooting_channel)
    sfx(sfx_id, player_shooting_channel and 3 or 0)
end

function _music_fade_out()
    music(-1, 500)
end