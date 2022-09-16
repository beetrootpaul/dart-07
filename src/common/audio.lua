-- -- -- -- -- -- -- --
-- common/audio.lua  --
-- -- -- -- -- -- -- --

-- SFXs shared between carts: 0 - 31
-- music and SFX individual for a cart: 32 - 64

_sfx_options_change = 0
--_sfx_options_prev = 1
_sfx_options_confirm = 2
_sfx_options_cannot_confirm = 3

_sfx_powerup_spawned = 4
_sfx_powerup_no_effect = 5
_sfx_powerup_heart = 6
_sfx_powerup_triple_shot = 7
_sfx_powerup_fast_shot = 8
_sfx_powerup_shockwave = 9

_sfx_player_shoot = 10
_sfx_player_triple_shoot = 11
_sfx_player_shockwave = 12
_sfx_enemy_shoot = 13
_sfx_enemy_multi_shoot = 14
 -- 15

_sfx_damage_player = 16
_sfx_damage_enemy = 17
_sfx_damage_boss = 18

_sfx_destroy_player = 19
_sfx_destroy_enemy = 20
_sfx_destroy_boss_phase = 21
_sfx_destroy_boss_final_1 = 22
_sfx_destroy_boss_final_2 = 23
_sfx_destroy_boss_final_3 = 24

function _sfx_play(sfx_id)
    sfx(sfx_id, 3)
end

function _music_fade_out()
    music(-1, 500)
end