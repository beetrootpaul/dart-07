pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- TODO shmup level 3
-- by beetroot paul

-- common code
#include build/src/common/buttons.lua
#include build/src/common/colors.lua
#include build/src/common/gameplay_area.lua
#include build/src/common/multicart.lua
#include build/src/common/tables.lua
#include build/src/common/viewport.lua

-- level specific values
_mission_number            = 3
_distance_scroll_per_frame = 3/8
_bg_color                  = _color_1_dark_blue

-- level specific code
#include build/src/level_carts/animated_sprite.lua
#include build/src/level_carts/fake_sprite.lua
#include build/src/level_carts/level.lua
#include build/src/level_carts/level_cart.lua
#include build/src/level_carts/level_descriptor.lua
#include build/src/level_carts/player.lua
#include build/src/level_carts/screen_get_ready.lua
#include build/src/level_carts/screen_mission_in_progress.lua
#include build/src/level_carts/static_sprite.lua

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
0000ddd000000000000000000000dddd0000000dd0000dddddddddddd00c000000000020000000ddcddd00000000000000000000000000000000000000000000
00dddbd000c0cd0c000000000c00ddd0dd00000dd0b00dd0ddd00ddd002000c0000000000000000ddd7000000000000000000000d0000b00000000000020020d
0dddddd0000ddd00000000000ddddd00ddd0000d00000d00d00020d70000000000000000000000000000000000000000000b002d7d00000200000000000000dd
0ddbddd00cdcdc00000dd020d2dddd00ddd0b0000dd00000020007d0dd002000000002000000000000000c00ddd000020000000ddd00200000000000000020dd
0dddddd000ddcd00000dd000ddd00020ddd000000ddd00000000ddd2ddd0000c000000dd000000000c00000dd7dd000000200000d0200000000000000200000d
00dddd0000c000c0000dd0000000c000dd000000dddd0d00ddddddddddddd0002000dddd00000000000000dddddd00200200000b200000b00000000000000020
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
ddddd0000000dddd0000dddd0000000dd0000dddddddddddd00c000000000020000000ddcddd00000000ddd000000000000000000000dddd0000000dd0000ddd
ddddd00000c0000d0c00ddd0dd00000dd0b00dd0ddd00ddd002000c0000000000000000ddd70000000dddbd000c0cd0c000000000c00ddd0dd00000dd0b00dd0
ddd00000000000000ddddd00ddd0000d00000d00d00020d7000000000000000000000000000000000dddddd0000ddd00000000000ddddd00ddd0000d00000d00
dd0000c000000000d2dddd00ddd0b0000dd00000020007d0dd002000000002000000000000000c000ddbddd00cdcdc00000dd020d2dddd00ddd0b0000dd00000
dd0c0000d0000000ddd00020ddd000000ddd00000000ddd2ddd0000c000000dd000000000c00000d0dddddd000ddcd00000dd000ddd00020ddd000000ddd0000
d0000000ddd000c00000c000dd000000dddd0d00ddddddddddddd0002000dddd00000000000000dd00dddd0000c000c0000dd0000000c000dd000000dddd0d00
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
000000000000000000000000000000000000dddd0000000dd0000ddddddddddd000000000000000000dddd0000d000000dddd00000ddd00000dddd0000ddd008
0000000000000000d0000b00000000000c00ddd0dd00000dd0b00dd0ddd00ddd000dd00000ddd00000000d0000d000000d0000000dd0000000000d0000d0d008
00000000000b002d7d000002000000000ddddd00ddd0000d00000d00d00020d70dddd0000000d000000ddd0000ddddd000ddddd00d0000000000d00000dd0008
ddd000020000000ddd00200000000000d2dddd00ddd0b0000dd00000020007d00000d000000dd00000000d0000000d0000000dd00dddddd00000d0000d00d008
d7dd000000200000d020000000000000ddd00020ddd000000ddd00000000ddd20000d0000ddddd000000dd0000000d000000dd000d0000d00000d0000d0dd008
dddd00200200000b200000b0000000000000c000dd000000dddd0d00dddddddd00000000000000000ddd000000000d0000ddd0000dddddd00000d0000ddd0008
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffff6fffffff6fffffff6fffffff6fffffff60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62222222622222226222222262222222622222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffff6fffffff6fffffff6fffffff6fffffff60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62222222622222226222222262222222622222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffff6fffffff6fffffff6fffffff6fffffff60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f6666662f6666662f6666662f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62222222622222226222222262222222622222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000fffffff6fffffff60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000f6666662f66666620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000062222222622222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000ss00ss00ss0sss0sss00000000000000000sss0000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000s000s000s0s0s0s0s000000000000s00000000s0000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000sss0s000s0s0ss00ss000000000000000000sss0000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000s0s000s0s0s0s0s000000000000s000000s000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ss000ss0ss00s0s0sss00000000000000000sss0000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff6ffffffssffsfsfsssfsssfsssfsssff6fffffff6111111sss111111111111111111111111111111111111111111111111111111111111111111111111111
666if66666sis6s6s6sss6s6s6sif6s6s66if66s666i11111111s111111111111111111111111111111111111111111111111111111111111111111111111111
666if66666sis6s6s6sis6ss66ssf6ss666if666666i11sss11ss111111111111111111111111111111111111111111111111111111111111111111111111111
666if66666sis6s6s6sis6s6s6sif6s6s66if66s666i11111111s111111111111111111111111111111111111111111111111111111111111111111111111111
666if66666sis66ss6sis6sss6sss6s6s66if666666i111111sss111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
iiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii111111111111111111111111111111111111111111111111111111111111111111111111111111111111
fff6fffffff6fffffff6fffffff6fffffff6fffffff6111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
iiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii111111111111111111111111111111111111111111111111111111111111111111111111111111111111
fff6fffffff61111111111111111fffffff6fffffff6111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i1111111111111111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i1111111111111111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i1111111111111111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i111111111jj11111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i11111111j11j1111f666666if666666i11111111111111111111111111111111111111111111111111111s11t111111111111111111111111111
666if666666i1111111111111111f666666if666666i11111111111111111111111111111111111111111111111111111111sst1111111111111111111111111
iiii6iiiiiii1111fjjjfjj111116iiiiiii6iiiiiii111111111111111111111111111111111111111111111111111111111111111111111111111111111111
fff6fffffff61111ffjjjff11111fffffff6fffffff6111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i1111111111111111f666666if666666i11111111111111111111111111111111111111111111111111111111sst1111111111111111111111111
666if666666i11111111j11j1111f666666if666666i11111111111111111111111111111111111111111111111111111s11t111111111111111111111111111
666if666666i111111111jj11111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i1111111111111111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i1111111111111111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666i1111111111111111f666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111111111111111
iiii6iiiiiii11111111111111116iiiiiii6iiiiiii111111111111111111111111111111111111111111111111111111111111111111111111111111111111
fff6fffffff6fffffff6fffffff6fffffff6fffffff61111111111111111111111111111111111111111111111111111111111111111fffffff6fffffff6ffff
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
iiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii11111111111111111111111111111111111111111111111111111111111111116iiiiiii6iiiiiii6iii
fff6fffffff6fffffff6fffffff6fffffff6fffffff61111111111111111111111111111111111111111111111111111111111111111fffffff6fffffff6ffff
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666if6t6666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
666if666666if666666ifi66t66if666666if666666i1111111111111111111111111111111111111111111111111111111111111111f666666if666666if666
iiii6iiiiiii6iiiiiiit6ttsfft6iiiiiii6iiiiiii11111111111111111111111111111111111111111111111111111111111111116iiiiiii6iiiiiii6iii
fff6fffffff6fffffff6t6ttffstfffffff6fffffff6111111111111111111111111111111111111111111111111fffffff6fffffff61111111111111111ffff
666if666666if666666ifi66t66if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
666if666666if666666if6t6666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111s11t1111111f666666if666666i11111s11t1111111f666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111sst11111f666666if666666i11111111sst11111f666
iiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii1111111111111111111111111111111111111111111111116iiiiiii6iiiiiii11111111111111116iii
fff6fffffff6fffffff6fffffff6fffffff6fffffff6111111111111111111111111111111111111111111111111fffffff6fffffff61111111111111111ffff
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111111sst11111f666666if666666i11111111sst11111f666
666if666666if666666if666666if666666if666666i1111111111111111111111111111111111111s11t1111111f666666if666666i11111s11t1111111f666
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666i1111111111111111f666
iiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii1111111111111111111111111111111111111111111111116iiiiiii6iiiiiii11111111111111116iii
fff6fffffff6fffffff6fffffff6fffffff6fffffff6111111111111111111111111111111111111111111111111fffffff6fffffff6fffffff6fffffff61111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
iiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii1111111111111111111111111111111111111111111111116iiiiiii6iiiiiii6iiiiiii6iiiiiii1111
fff6fffffff6fffffff6fffffff6fffffff6fffffff6111111111111111111111111111111111111111111111111fffffff6fffffff6fffffff6fffffff61111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
666if666666if666666if666666if666666if666666i111111111111111111111111111111111111111111111111f666666if666666if666666if666666i1111
iiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii6iiiiiii1111111111111111111111111111111111111111111111116iiiiiii6iiiiiii6iiiiiii6iiiiiii1111
fff6fffffff6fffffff6fffffff61111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111s11t111111111111111111111111111
666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111sst1111111111111111111111111
iiii6iiiiiii6iiiiiii6iiiiiii1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
fff6fffffff6fffffff6fffffff61111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111111sst1111111111111111111111111
666if666666if666666if666666i111111111111111111111111111111111111111111111111111111111111111111111s11t111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
666if666666if666666if666666i1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
iiii6iiiiiii6iiiiiii6iiiiiii1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004800f800ffffffff0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff
__sfx__
000100002365027650296502b6502b6502b6502b650256501f6501465007650036500365004650056500a6500d650156501a6501b650186500065002650036500565005650046500365003650086501165019650
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000022150271502e150301503015030150301502e150271501f1501b1501d1502215024150271502b1502e150301503315000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000000000366503b6503d6503965031650276501e65010650176501d65017650136500e6500f650106500f65017650246502c650376503f650000000000000000000000000038650316501b6501365017650
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000c0000371503715037150371503715037150371500315005150071500c150111501815018150161501615016150181501d150221502915029150291502e1502e150331503515037150371503a1503a1503a150
__music__
04 14424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
04 1e424344

