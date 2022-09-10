pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
-- TODO shmup game title
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

#include build/src/cart_main/screen_brp.lua
#include build/src/cart_main/screen_select_mission.lua

#include build/src/cart_main.lua

__gfx__
00000000bbbb11bbbbbbbb11bbbbbbbb11bbbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
00000000bbb18f1bbbbbb18f1bbbbbb1df1bbbbbbbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000bbbbbbbb1677771b
00700700bbb1881bbbbbb1881bbbbbb1881bbbbbbbbbbbbbbaaabbbd00000000000000000000000000000000000000000000000000000000bbbbbbb167878771
00077000bb1d88f1bbbb1d88f1bbbb1d88f1bbbbbbbbbbbbcccaabbd00000000000000000000000000000000000000000000000000000000bbbbbbb168888871
00077000b1d8888f1bb1d8888f1bb1d8888f1bbbbbbbbbbbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb167888771
00700700b1d8688f1b1d886688f1b1f8868f1bbbbbbbbbbbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb166787761
00000000b1d888881b1888888881b1f888881bbbbbbddbbbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbb1666661b
00000000b1dd8d881b188d8fd881b1f8d8d81bbbbbbbbddbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
a99a0990bb11dd11bbb111dd111bbb11dd11bbbbdbbbbbbbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
affa0ff0bbbb11bbbbbbbb11bbbbbbbb11bbbbbbdb8bbbbbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbb1677771b
0aa00aa0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbd88bbbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb167787771
00000aa0bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbd8888bccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb168797871
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbd8888fccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb169777971
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbd8888fccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb166777761
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbd8888fccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbb1666661b
00000000bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbd8888fccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
b88bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8888fccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
8998bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb88fccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbbb1677771b
9ff9bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb8ccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb167787771
9ff9bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbbbbbbbccccabbd00000000000000000000000000000000000000000000000000000000bbbbbbb167878771
bffbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdbbbbbbdcccdbbd00000000000000000000000000000000000000000000000000000000bbbbbbb167797771
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbddbbbbbdddbbbd00000000000000000000000000000000000000000000000000000000bbbbbbb166979761
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbddbbbbbbbbdd00000000000000000000000000000000000000000000000000000000bbbbbbbb1666661b
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbdddddddddd00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
0000000000000000000000000000000000000000bd8d8bbbbcccccbb00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
0000000000000000000000000000000000000000d888f8bbccaaaccb00000000000000000000000000000000000000000000000000000000bbbbbbbb1677771b
0000000000000000000000000000000000000000d88888bbcabbbacb00000000000000000000000000000000000000000000000000000000bbbbbbb167ccc771
0000000000000000000000000000000000000000bd888bbbcbbcbbcb00000000000000000000000000000000000000000000000000000000bbbbbbb16caaac71
0000000000000000000000000000000000000000bbd8bbbbbbcacbbb00000000000000000000000000000000000000000000000000000000bbbbbbb16ca7ac71
0000000000000000000000000000000000000000bbbbbbbbbbbcbbbb00000000000000000000000000000000000000000000000000000000bbbbbbb1667c7761
0000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000bbbbbbbb1666661b
0000000000000000000000000000000000000000bbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000bbbbbbbbb11111bb
f000fff0fff0fff0000000000fff0000d000ddd0ddd0ddd0000000000ddd00000000000000000000000000000000000000000000000000000000000000000000
ff00ff00ff000f000000fff0f00f0000dd00dd00dd000d000000ddd0d00d00000000000000000000000000000000000000000000000000000000000000000000
f0f0f000f0000f00000fff0f00f0f000d0d0d000d0000d00000ddd0d00d0d0000000000000000000000000000000000000000000000000000000000000000000
fff0fff0fff00f0000ffff0f0f00f000ddd0ddd0ddd00d0000dddd0d0d00d0000000000000000000000000000000000000000000000000000000000000000000
00000000000000000ffffffff0ff000000000000000000000dddddddd0dd00000000000000000000000000000000000000000000000000000000000000000000
ff000ff00ff0fff0000f0fff000f0000dd000dd00dd0ddd0000d0ddd000d00000000000000000000000000000000000000000000000000000000000000000000
f0f0f0f0f0f00f000000fff0f000f000d0d0d0d0d0d00d000000ddd0d000d0000000000000000000000000000000000000000000000000000000000000000000
ff00f0f0f0f00f00000000000fff0000dd00d0d0d0d00d00000000000ddd00000000000000000000000000000000000000000000000000000000000000000000
f0f0ff00ff000f000000000000000000d0d0dd00dd000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fff0ff00f0f0f000000ff00ff0fff000ddd0dd00d0d0d000000dd00dd0ddd0000000000000000000000000000000000000000000000000000000000000000000
f0f0f0f0f0f0f00000f000f0f0fff000d0d0d0d0d0d0d00000d000d0d0ddd0000000000000000000000000000000000000000000000000000000000000000000
ff00fff0f0f0f00000f000f0f0f0f000dd00ddd0d0d0d00000d000d0d0d0d0000000000000000000000000000000000000000000000000000000000000000000
f000f0f0ff00ff00f00ff0ff00f0f000d000d0d0dd00dd00d00dd0dd00d0d0000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
e000eee0eee0eee0000000000eee0000200022202220222000000000022200000000000000000000000000000000000000000000000000000000000000000000
ee00ee00ee000e000000eee0e00e0000220022002200020000002220200200000000000000000000000000000000000000000000000000000000000000000000
e0e0e000e0000e00000eee0e00e0e000202020002000020000022202002020000000000000000000000000000000000000000000000000000000000000000000
eee0eee0eee00e0000eeee0e0e00e000222022202220020000222202020020000000000000000000000000000000000000000000000000000000000000000000
00000000000000000eeeeeeee0ee0000000000000000000002222222202200000000000000000000000000000000000000000000000000000000000000000000
ee000ee00ee0eee0000e0eee000e0000220002200220222000020222000200000000000000000000000000000000000000000000000000000000000000000000
e0e0e0e0e0e00e000000eee0e000e000202020202020020000002220200020000000000000000000000000000000000000000000000000000000000000000000
ee00e0e0e0e00e00000000000eee0000220020202020020000000000022200000000000000000000000000000000000000000000000000000000000000000000
e0e0ee00ee000e000000000000000000202022002200020000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
eee0ee00e0e0e000000ee00ee0eee000222022002020200000022002202220000000000000000000000000000000000000000000000000000000000000000000
e0e0e0e0e0e0e00000e000e0e0eee000202020202020200000200020202220000000000000000000000000000000000000000000000000000000000000000000
ee00eee0e0e0e00000e000e0e0e0e000220022202020200000200020202020000000000000000000000000000000000000000000000000000000000000000000
e000e0e0ee00ee00e00ee0ee00e0e000200020202200220020022022002020000000000000000000000000000000000000000000000000000000000000000000
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
0000000000ss00s0s0sss0sss0sss0sss00000000000000000sss000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000s0s0s0s0sss0s0s0s000s0s000000s000000000000s000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000s0s0s0s0s0s0ss00ss00ss00000000000000sss00ss000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000s0s0s0s0s0s0s0s0s000s0s000000s000000000000s000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000s0s00ss0s0s0sss0sss0s0s00000000000000000sss000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000s000sss0s0s0sss0s0000000ss000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000s000s000s0s0s000s00000000s000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000s000ss00s0s0ss00s00000000s000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000s000s000sss0s000s00000000s000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000sss0sss00s00sss0sss00000sss00000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000010001110101011101000000011100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000010001000101010001000000000100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000010001100101011001000000011100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000010001000111010001000000010000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011101110010011101110000011100000000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000010001110101011101000000011100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000010001000101010001000000000100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000010001100101011001000000001100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000010001000111010001000000000100000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000011101110010011101110000011100000000000000000000000000000000000000000000000000000000000000000000000
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

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f800ffffffff000000000000000000ffffffffffffff000000000000000000ffffffffffffff0000000000000000ffffffffffffffff
