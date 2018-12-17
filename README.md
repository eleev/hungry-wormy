# hungry-wormy [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

[![Platforms](https://img.shields.io/badge/platforms-macOS%20%26%20iOS-yellow.svg)]()
[![Language](https://img.shields.io/badge/language-Swift-orange.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

**Last Update: 17/December/2018.**

![](logo-hungry_wormy.png)

# ✍️ About
🐛 `Hungry Wormy` is a retro game reincarnation implemented on top of SpriteKit framework for `iOS` & `macOS`.

# 📺 Demo
Please wait while the `.gif` files are loading...

<p align="center">
  <img src="Assets/Demo/Demo00.gif" width="285" />
</p>

<p float="left">
  <img src="Assets/Demo/Demo01.gif" width="285" /> 
  <img src="Assets/Demo/Demo02.gif" width="285" />
  <img src="Assets/Demo/Demo03.gif" width="285" />
</p>

# 🍱 Features
- Cross-platform: `macOS` & `iOS`. `tvOS` can be easily added as an update.
- `Extendable`, `data-driven` archtiecture: you can easily add a new level without any programming (well, almost 😄). 
- **Six** levels: from very trivial to insane diffuculty level.
- Fully native implementation: `Swift` & `SpriteKit` only. 
- `No external` dependencies.

# 📝 Controls

## iOS
On `iOS` all the controlls are handled by `swipe` gestures. There are **4** gestures for swipe `up`, `left`, `down` and `right`. You will get the `haptic` feedback on the supported devices for when the `direction` of the `wormy` is changed. If you double swipe to a direction, the second swipe will be ignored.

## macOS
On `macOS` all the controlsl are handled by `arrow` keys. There are **4** keys for turning to `up ⬆️`, `left ⬅️`, `down ⬇️` and `right ➡️` directions. If you double tap to a direction, the second one will be ignored. In order to `pause/resume` the game you need to tap on `escape` key. 

# 🔗 Dependencies
The project currently has one dependency, which is [device-kit](https://github.com/jVirus/device-kit) framework.

# 🏗 How to create a new level

# 👨‍💻 Author 
[Astemir Eleev](https://github.com/jVirus)

# 🔖 Licence
The project is available under [MIT licence](https://github.com/jVirus/hungry-wormy/blob/master/LICENSE)

[device-kit](https://github.com/jVirus/device-kit) framework is available under [MIT licence](https://github.com/jVirus/device-kit/blob/master/LICENSE)
