pico-8 cartridge // http://www.pico-8.com
version 36
__lua__
-- TODO shmup game title
-- by beetroot paul

-- common code
#include build/src/common/buttons.lua
#include build/src/common/colors.lua
#include build/src/common/font_4px.lua
#include build/src/common/gameplay_area.lua
#include build/src/common/multicart.lua
#include build/src/common/tables.lua
#include build/src/common/text_4px.lua
#include build/src/common/viewport.lua

-- cart specific code
#include build/src/main_cart/main_cart.lua
#include build/src/main_cart/screen_level_select.lua
#include build/src/main_cart/screen_title.lua

__gfx__
00000000bbbbbbbbbbbbbbb000bbbbbbbbbb88888888bbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb0000bbbbbbbb02220bbbbbbbb89999999988bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700b088ff0bbbbb00222220bbbbbb8999999999998b00000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000b0d888f00bb022256980bbbbb89999999999998b00000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000d886888f0022d255220bbbb899999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000dd88888d002f56f6f0bbbbb899999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b08888d00b0265f6f60bbbbb899999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b0fffd0bbb022d255220bbbb899999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000077bb0000bbbbb022256980bbbb899999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
77f907f9bbbbbbbbbbbb00222220bbbb899999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
77f907f9bb000bbbbbbbbb02220bbbbb899999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000077b088f0bbbbbbbbb000bbbbbbb89999999999999800000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b0888f0bbbb00000bbbbbbbbb89999999999998b00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b0d888f00b0566290bbbbbbbbb8999999999998b00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000df86888f006ff50bbbbbbbbbbb89999999988bb00000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d8868888006ff50bbbbbbbbbbbb88888888bbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b0d888d00b0566290bbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b0888d0bbbb00000bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b088d0bbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb000bbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb0000bbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b088ff0bbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b08888f00bbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000dd88888f0bbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d88688880bbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b0d888d00bbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b0dddd0bbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb0000bbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbbbbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bb00b0000bb0bb00bbb0bbb00bb0b000b0bb0b0b0b00bbb0bb000bb0bbb00b00bb000bb0bbb0b0b0b0b0b0b0b0b0b0b0bbb0000000b000bbb000bbb000b00000
b0b0bb00b000b0b0bb00b000b000bb00b00b0bb00b00bbb0b0b0b0b0b0b0b0b0b0b0bb000b00b0b0b0b0b0b00b00b0b00b0000000bb00b000b0b0b0b0bbbb000
bbb0b0b0b000b0b0b000bb00b0b0b0b0b00b0b0b0b00b0b0b0b0b0b0bb00bbb0bb0000b00b00b0b0b0b0bbb0b0b00b00b000bb0000bb0b0b0b0bb0bb00b0b000
b0b0bbb00bb0bb00bbb0b0000bb0b0b0b0b00b0b0bb0b0b0b0b0bb00b0000b00b0b0bb000b00bb000b00bbb0b0b00b00bbb0000b00b00b000b0b0b0b0000b000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008bbb808bbb80000b0bb
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000888000888000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b0bb00bbb0b0b0bbb00b00bbb0bbb0bbb00b0000b000bbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000
bb00bb00bb0b0b0bb00b00000b00b00bbb0b0b0bbbbb0b0b0b000000000000000000000000000000000000000000000000000000000000bbb000bbb000000000
0b0b00000b0bbb000b0bbb00b00b0b000b0b0b00bbb00bbbbb00000000000000000000000000000000000000000000000000000000000b000b0b0b0b00000000
0b0bbb0bbb000b0bb000b00b0000b00bb000b000b0b000b0b000000000000000000000000000000000000000000000000000000000000b0b0b0bb0bb00000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000b000b0b0b0b00000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000bbb000bbb000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
dbb888bb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bdbb888b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bdbb888b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbdbb888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004800f800ffffffff0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff0000000000000000ffffffffffffffff
__sfx__
000100001a1501c1501e15020150191501315012150121501515019150201502c1503415000100001000010000100001000010000100001000010000100001000010000100001000010000100001000010000100
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000000002b5502f550305500e55010550125501655018550195501b5501b550195500f5500e5500e5500e5500e5500d5500b5500d55010550155501c550235502a550305503655000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000000000293502935029350273502435022350000000000000000133501635016350000001b350000001f3502235022350273502b3503335035350353502735022350000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001f7501d7501b7501b75018750167500a75016750167503a7503a7503a7503a750167501f7500000000000000000f75018750377503c7503c750377503375033750000000000000000000000000000000
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

