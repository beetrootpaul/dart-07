pico-8 cartridge // http://www.pico-8.com
version 37
__lua__
-- TODO shmup mission 1 title
-- by beetroot paul

#include build/src/third_party/easingcheatsheet.lua

#include build/src/common/timer/fake_timer.lua
#include build/src/common/timer/timer.lua
#include build/src/common/buttons.lua
#include build/src/common/colors.lua
#include build/src/common/font_4px.lua
#include build/src/common/gameplay_area.lua
#include build/src/common/multicart.lua
#include build/src/common/tables.lua
#include build/src/common/text_4px.lua
#include build/src/common/throttle.lua
#include build/src/common/viewport.lua

#include build/src/cart_mission/gui/hud.lua
#include build/src/cart_mission/gui/mission_info.lua
#include build/src/cart_mission/movement/movement_angled_line.lua
#include build/src/cart_mission/movement/movement_sinusoidal.lua
#include build/src/cart_mission/movement/movement_stationary.lua
#include build/src/cart_mission/movement/movement_wait_then_charge.lua
#include build/src/cart_mission/sprites/animated_sprite.lua
#include build/src/cart_mission/sprites/fake_sprite.lua
#include build/src/cart_mission/sprites/static_sprite.lua
#include build/src/cart_mission/collisions.lua
#include build/src/cart_mission/enemy.lua
#include build/src/cart_mission/enemy_bullet.lua
#include build/src/cart_mission/level.lua
#include build/src/cart_mission/level_descriptor.lua
#include build/src/cart_mission/player.lua
#include build/src/cart_mission/player_bullet.lua
#include build/src/cart_mission/powerup.lua
#include build/src/cart_mission/screen_intro.lua
#include build/src/cart_mission/screen_mission.lua

#include build/src/cart_mission.lua
#include build/src/mission_1.lua

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
00000ccccc000cc0cc0000003333bb223333bb2200e00ee000000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
0000cccccccccccccccc0000b332333bbb32333b0e00e00000000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
000cccd222dccddd2dccc000bbbb23bb33bb23bbe00e000000000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
00ccd222bb22bb22222dcc003b33bb32223bb33300e0000e00000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
0ccd2bb2333bbbb3bb22cc00223b332dd2333b330e0000e000000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
0cc2b3bbbb333b3333b2dcc0bb33332dd22bb322e0000e0000000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
0cd23333bbbb333b3bb22cc0bbbb32dccd23bb3b000ee00e00000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
cc2233323b3bb333b33b2dc03b3bddccccdd33b300e0000e00000000000000000000000000000000000000000000000000000000cccccccc9999999977777777
ccd2bb223333bb223333bdcc32ddccccccccdd230e000ee000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc2333bb332333bb3322ccc3ddcccccccccccd2e000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ccd33bbbbbb23bbbbbb2cc02dcccc00000cccc2000e000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
0cdbb3333b33bb333b33bcc0dccc000000000ccd00e000e000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cd3bb33223bbbb3233332c0ccc0000000000ccc0e000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c233b22bb333b32bb3322c0cc000000000000cce00ee00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c23333bbbb3333bbbbbd2cccc000000000000cc00e0000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
ccd3b3333b3bb3333b3bbdcccc000000000000cc00e0000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
cc23bb223333bb2233332dcccc000000000000cc0e00000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
cc23333bb332333bb332dccccc000000000000cce0000ee000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cd233bbbbbb23bbbb22dcc0cc000000000000cc0000e00e00000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc22223bb332233322dcc00dcc00000000000cc000e00e000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cccd2223222dd2322ddcc00dcc0000000000ccd00e00e0000000000000000000000000000000000000000000000000000000000000000000000000000000000
000cccddccdddcccddccc000ddccc000000cccc20e0ee00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000cccccccccccccccc00002ddccccc00ccccd3e0e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000ccc00000ccccc00000bb2dccccccccdd2300e0000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee222200000000000000003332ddccccddbbb200e0000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee22220000000000000000b33322dccd2233bb0e000ee000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee22220000000000000000bbb3bb2dd223333be000e00000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee222200000000000000003b333bbdd223b333000e000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee00000000000000003333bb33233bbb3300e000e000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee0000000000000000bb333332bb333b220e000e0000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee0000000000000000bbbb3333bbbb333be00ee00000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee00000000000000003b3bb3333b3bb33300e0000e00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb1111111bbbbbb111bb111bbb1bb1b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000880
bb1999999911bbb1282112821b1911910000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000089f8
b199999999991b12292f629221125521000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008998
b199999999991b122656f5622116ff61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000880
1999999999999112255f65522116ff61000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19999999999991b12226f2221b156651000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19999999999991bb12d55d21bbb1111b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19999999999991bb122f6221bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19999999999991bbb111111bbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19999999999991bbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19999999999991bbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
19999999999991bbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1999999999991bbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b199999999991bbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb1999999911bbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb1111111bbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb11111bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb11111bbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb11ddd11111bbbbbbbbbb11111111bbbbbbbbbb11111ddd11bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb1dddddd2211111111111122dd2211111111111122dddddd1bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb1ddddddd222222222222222dd222222222222222ddddddd1bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbb11ddddddddd2222222222dddddddd2222222222ddddddddd11bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbb1dddddddddddddddddddddddddddddddddddddddddddddddd1bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbb1dddddddddddddddddddddddddddddddddddddddddddddddd1bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbb1dddddddddddddddddddddddddddddddddddddddddddddddd1bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbb1dddddddddddddddddddddddddddddddddddddddddddddddd1bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbb11dddddddddddddddddddddddddddddddddddddddddddddddd11bbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbb12dddddddddddddddd111dddddddddd111dddddddddddddddd21bbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbb112ddddddddd1111111bb11dddddddd11bb1111111ddddddddd211bbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbb1122ddddddddd1bbbbbbbbb1dddddddd1bbbbbbbbb1ddddddddd2211bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbb1222ddddddddd1bbbbbbbbb1dddddddd1bbbbbbbbb1ddddddddd2221bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbb122ddd99dddd21bbbbbbbbb1dddddddd1bbbbbbbbb12dddd99ddd221bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbb122dd9999ddd21bbbbbbbbb11dddddd11bbbbbbbbb12ddd9999dd221bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbb122dd9999dd221bbbbbbbbbb1dddddd1bbbbbbbbbb122dd9999dd221bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbb112ddd99ddd211bbbbbbbbbb1dd99dd1bbbbbbbbbb112ddd99ddd211bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbb12ddddddd221bbbbbbbbbbb1dd99dd1bbbbbbbbbbb122ddddddd21bbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbb12ddddddd22bbbbbbbbbbbbb1d99d1bbbbbbbbbbbbb22ddddddd21bbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbb1dddddd221bbbbbbbbbbbbbb1111bbbbbbbbbbbbbb122dddddd1bbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbb11ddddd21bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb12ddddd11bbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbb1dddd11bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb11dddd1bbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb1dd11bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb11dd1bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb1111bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb1111bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb11bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb11bbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
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
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjsssjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjsjjjjjjjjjjjjsjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjsssjjssjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjsjjjjjjjjjjjjsjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjsssjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssss00sss0ssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssss0i00i00ssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssii0iii0ssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssssii0iii0ssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
sssssssssssssssssssssss0i00i00ssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssss00sss0ssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
sssssssssssssssssssss6tsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
ssssssssssssssssssssfi66tsssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
sssssssssssssssssssst6ttsfftssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjj
sssssssssssssssssssst6ttffstssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssfi66tsssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
sssssssssssssssssssss6tsssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjsssssssssjjsssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssjssjssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssfjjjfjjsssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssffjjjffsssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssjssjssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjsssssssssjjsssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssjjjjjjjjjjjjjjjjssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssss00sss0ss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjsssss0i00i00ss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjsssssii0iii0ss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjsssssii0iii0ss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjsssss0i00i00ss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssss00sss0ss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
ssssssssssssssssssssssssssssssssssjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjssssssssssssss
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
__map__
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
00515151000000000000515151515100004e7000000000000000000000000000000000000000000000515151510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
4d000000000000000000514f5151000000517000000000000000510000000051515151515100000000005151510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
0000510051515100000051515100000000517000000051510000000000005151510000005151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
0000000051515151000000515100000000517000000051510000000000000000515100005151515100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
00005151514f5100000000000000000000517000000000000000510000000000005151515151515100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
00000051515151000000000000000000004e7000000000000000000000000000000000515151510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
