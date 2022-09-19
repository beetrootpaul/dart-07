# Dart-07

> TODO short description

TODO project context: Lazy Devs' Shmup Showcase

Published on: https://beetrootpaul.itch.io/dart-07

**Controls**

- TODO
- TODO

---


TODO longer description

TODO player ship
TODO sample enemies
TODO powerups and their meaning

---

TODO any other info, i.e. about being a PICO-8 game

PICO-8 version use to develop this game: `0.2.5c`

TODO mention multi-cart setup and that it's maybe not necessary, but wanted to have it for learning purposes

TODO mention cross-cart data graphics and SFX copying as well

TODO link to #easingcheatsheet https://www.lexaloffle.com/bbs/?tid=40577

---

TODO screenshots

## Code style

That this game runs on PICO-8, which has a token count limit.
It means, in a lot of situations a code clarity had to be sacrificed
in order to squeeze one more enemy or to implement a score display ¯\_(ツ)_/¯

## Development

1. (optional) Install [nvm](https://github.com/nvm-sh/nvm)
2. (optional) Run `nvm install` to setup proper Node.js version
3. (once) Run `npm install` to download dependencies
4. Run `npm start` to start a watcher which generates minified Lua sources for
   the game every time a file is changed. Please be aware all files has to be
   included (`#include`) manually in the cart's Lua itself.
5. Start PICO-8 and load [dart-07.p8](dart-07.p8) cart

Optionally, to build without minification: `npm run watch-and-build-as-is`

To build dist packages:

- remove cart data file from PICO-8 cart data folder (as set in `$HOME/Library/Application Support/pico-8/config.txt`)
- then run `npm run dist`

To update the sprite sheet of, for example, mission 1:

- edit `graphics/spritesheet_mission_1.aseprite` in Aseprite (please remember you have to use official standard 16
  PICO-8 colours so they will match on import)
- export to PNG with scale 100%
- load cart and run `import graphics/spritesheet_mission_1.png` or `import dart-07/graphics/spritesheet_mission_1.png` (
  depends on what your current working directory is)
