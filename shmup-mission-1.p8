pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- TODO shmup mission 1 title
-- by beetroot paul

#include build/src/third_party/easingcheatsheet.lua

#include build/src/common/movement/movement_fixed_factory.lua
#include build/src/common/movement/movement_line_factory.lua
#include build/src/common/movement/movement_loop_factory.lua
#include build/src/common/movement/movement_sequence_factory.lua
#include build/src/common/movement/movement_sinusoidal_factory.lua
#include build/src/common/movement/movement_to_target_factory.lua

#include build/src/common/timer/fake_timer.lua
#include build/src/common/timer/timer.lua

#include build/src/common/buttons.lua
#include build/src/common/colors.lua
#include build/src/common/common.lua
#include build/src/common/fade.lua
#include build/src/common/gameplay_area.lua
#include build/src/common/multicart.lua
#include build/src/common/throttle.lua
#include build/src/common/utils.lua
#include build/src/common/viewport.lua
#include build/src/common/xy.lua

#include build/src/cart_mission/game/boss.lua
#include build/src/cart_mission/game/collisions.lua
#include build/src/cart_mission/game/enemy.lua
#include build/src/cart_mission/game/enemy_bullet_factory.lua
#include build/src/cart_mission/game/explosion.lua
#include build/src/cart_mission/game/game.lua
#include build/src/cart_mission/game/level.lua
#include build/src/cart_mission/game/level_descriptor.lua
#include build/src/cart_mission/game/player.lua
#include build/src/cart_mission/game/player_bullet.lua
#include build/src/cart_mission/game/powerup.lua
#include build/src/cart_mission/game/shockwave.lua

#include build/src/cart_mission/gui/boss_info.lua
#include build/src/cart_mission/gui/hud.lua
#include build/src/cart_mission/gui/mission_info.lua

#include build/src/cart_mission/sprites/animated_sprite.lua
#include build/src/cart_mission/sprites/fake_sprite.lua
#include build/src/cart_mission/sprites/static_sprite.lua

#include build/src/cart_mission/screen_defeat.lua
#include build/src/cart_mission/screen_mission_boss.lua
#include build/src/cart_mission/screen_mission_end.lua
#include build/src/cart_mission/screen_mission_main.lua
#include build/src/cart_mission/screen_over.lua
#include build/src/cart_mission/screen_win.lua

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
00000ccccc000cc0cc0000003333bb223333bb2200e00ee00e000ee00e00000e00e0000e2200002200000000ee0000ee44000044cc0000cc9900009977000077
0000cccccccccccccccc0000b332333bbb32333b0e00e000e000e000e0000ee00e000ee02002200200000000e000000e40044404c000000c9000000970077007
000cccd222dccddd2dccc000bbbb23bb33bb23bbe00e0000000e000e0000e00ee000e0000022200000000000000ee00000004400000000000099990000777700
00ccd222bb22bb22222dcc003b33bb32223bb33300e0000e00e000e0000e00e0000e000e002222200000000000eeee0000004400000ccc000999900007777770
0ccd2bb2333bbbb3bb22cc00223b332dd2333b330e0000e00e000e0000e00e0000e000e0002222200000000000eeee0000004400000ccc000999900007777770
0cc2b3bbbb333b3333b2dcc0bb33332dd22bb322e0000e00e00ee0000e0ee0000e000e000022200000000000000ee00000004400000000000099990000777700
0cd23333bbbb333b3bb22cc0bbbb32dccd23bb3b000ee00e00e0000ee0e00000e00ee0002002200200000000e000000e40044404c000000c9000000970077007
cc2233323b3bb333b33b2dc03b3bddccccdd33b300e0000e00e0000e00e0000e00e0000e2200002200000000ee0000ee44000044cc0000cc9900009977000077
ccd2bb223333bb223333bdcc32ddccccccccdd23000000000000000000000000000000002233332233333333ee3333ee44333344cc3333cc9933339977333377
0cc2333bb332333bb3322ccc3ddcccccccccccd2000000000000000000000000000000002332233233333333e333333e43344434c333333c9333333973377337
0ccd33bbbbbb23bbbbbb2cc02dcccc00000cccc2000000000000000000000000000000003322233333333333333ee33333334433333333333399993333777733
0cdbb3333b33bb333b33bcc0dccc000000000ccd00000000000000000000000000000000332222233333333333eeee3333334433333ccc333999933337777773
0cd3bb33223bbbb3233332c0ccc0000000000ccc00000000000000000000000000000000332222233333333333eeee3333334433333ccc333999933337777773
0c233b22bb333b32bb3322c0cc000000000000cc000000000000000000000000000000003322233333333333333ee33333334433333333333399993333777733
0c23333bbbb3333bbbbbd2cccc000000000000cc000000000000000000000000000000002332233233333333e333333e43344434c333333c9333333973377337
ccd3b3333b3bb3333b3bbdcccc000000000000cc000000000000000000000000000000002233332233333333ee3333ee44333344cc3333cc9933339977333377
cc23bb223333bb2233332dcccc000000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
cc23333bb332333bb332dccccc000000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cd233bbbbbb23bbbb22dcc0cc000000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cc22223bb332233322dcc00dcc00000000000cc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cccd2223222dd2322ddcc00dcc0000000000ccd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000cccddccdddcccddccc000ddccc000000cccc20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000cccccccccccccccc00002ddccccc00ccccd30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000ccc00000ccccc00000bb2dccccccccdd230000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee222200000000000000003332ddccccddbbb20000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee22220000000000000000b33322dccd2233bb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee22220000000000000000bbb3bb2dd223333b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eeee222200000000000000003b333bbdd223b3330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee00000000000000003333bb33233bbb330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee0000000000000000bb333332bb333b220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee0000000000000000bbbb3333bbbb333b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2222eeee00000000000000003b3bb3333b3bb3330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbb1111111bbbbbb111bb111bbb1bb1bbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb8888bb88b
bb1999999911bbb1282112821b191191bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbb8999988978
b199999999991b12292f629221125521bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbb8977988998
b199999999991b122656f5622116ff61bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbb897798b88b
1999999999999112255f65522116ff61bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbb899998bbbb
19999999999991b12226f2221b156651bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbb8888bbbbb
19999999999991bb12d55d21bbb1111bbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
19999999999991bb122f6221bbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
19999999999991bbb111111bbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
19999999999991bb111bbbbbb11111111111111b000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
19999999999991b12221bbbb1446666666666441000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
19999999999991129f921bbb1466666666666641000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
1999999999991b12fff21bbb1666666666666661000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
b199999999991b129f921bbb1666111111116661000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
bb1999999911bbb12221bbbb1661bbbbbbbb1661000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
bbb1111111bbbbbb111bbbbb1881bbbbbbbb1881000000000000000000000000000000000000000000000000000000000000000000000000bbbbbbbbbbbbbbbb
bbbbbbb11bbbbbbbbbbbbbbbb11bbbbbbbbbb11b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb1551bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb1551bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb155111111bbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b111115555555551bbbbbbbbb111bbb111bbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1555555555555551bbbbbbbb19991119991bbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1555556666655651bbbbbbbb12222222221bbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1556566666665651bbbbbbbb12fffffff21bbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1556566666665651bbbbbbbb1222fff2221bbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1556566666665551bbbbbbbbb162222261bbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1556555555555551bbbbbbbbbb1622261bbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
15565ccccccc5551bbbbbbbbbbb16261bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
155555cccccc5551bbbbbbbbbbb16261bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b111115cccc5111bbbbbbbbbbbb16261bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbb155551bbbbbbbbbbbbbbb16661bbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbb1111bbbbbbbbbbbbbbbbb111bbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddd8888888888888888888888888888dddd8888ddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddd8sss8sss88ss88ss8sss88ss8ss88ddd8ss8ddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddd8sss88s88s888s8888s88s8s8s8s8ddd88s8ddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddd8s8s88s88sss8sss88s88s8s8s8s8dddd8s8ddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddd8s8s88s8888s888s88s88s8s8s8s8ddd88s88dddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddd8s8s8sss8ss88ss88sss8ss88s8s8ddd8sss8dddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddd88888888888888888888888888888ddd88888dddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
00000000000000008888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888880000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddddddd11ddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddd18v1dddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddd1881dddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddddd1t88v1ddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddd1t8888v1dddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddd1t886688v1ddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddd1888888881ddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddd188t8vt881ddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddd111tt111dddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddddddd11ddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddddddcppcdddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000ddddddddddddddddddddddddddddddddddddddddddddddcvvcdddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddccddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000
0000000000000000dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd0000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004800f800ffffffff0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff
__map__
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
005151510000004c4b0051515151510070000000000000000000000000000000000000000000000000515151510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
4d00000000000000000051595151000070510000000000000000510000000051515151515100000000005151510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
0000510051515100000051515100000070510000000051510000000000005151510000005151000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
004e000051515151000000515100000070510000000051510000000000000000515100005151515100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
00005151515f5100000000000000000070510000000000000000510000000000005151515151515100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
0000005151515100000000000000000070000000000000000000000000000000000000515151510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000070
7070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070707070
