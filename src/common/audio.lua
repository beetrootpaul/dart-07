-- -- -- -- -- -- -- --
-- common/audio.lua  --
-- -- -- -- -- -- -- --

-- TODO: final double check: if ranges in the comment are up to date
-- SFXs shared between carts: 0 - 31
-- SFXs individual for a cart: 32 - 39 (i.e. various enemy shooting types or an extra SFX for a logo screen)
-- music individual for a cart: 40 - 64

_sfx_options_change = 0
-- TODO: use it?
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
-- TODO: use it?
--_sfx_player_cannot_shockwave = 13

_sfx_damage_player = 14
_sfx_damage_enemy = 15
-- TODO: use it?
--_sfx_damage_enemy_shockwave = 16
_sfx_damage_boss = 17
-- TODO: use it?
--_sfx_damage_boss_shockwave = 18

_sfx_destroy_player = 19
_sfx_destroy_enemy = 20
_sfx_destroy_boss_phase = 21
_sfx_destroy_boss_final_1 = 22
_sfx_destroy_boss_final_2 = 23
_sfx_destroy_boss_final_3 = 24
