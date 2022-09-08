# WIP Shmup

TODO better title

> TODO short description

TODO project context: Lazy Devs' Shmup Showcase

TODO itch.io link

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

---

TODO screenshots

---

Development:

1. (optional) Install [nvm](https://github.com/nvm-sh/nvm)
2. (optional) Run `nvm install` to setup proper Node.js version
3. (once) Run `npm install` to download dependencies
4. Start PICO-8 and load [shmup.p8](shmup.p8) cart
5. Run `npm start` to start a watcher which generates minified Lua sources for
   the game every time a file is changed. Please be aware all files has to be
   included (`#include`) manually in the cart's Lua itself.

Optionally, to build without minification: `npm run watch-and-build-as-is`

To build dist packages: `npm run dist`