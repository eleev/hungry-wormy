# hungry-wormy [![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/sindresorhus/awesome)

[![Platforms](https://img.shields.io/badge/platforms-macOS%20%26%20iOS-yellow.svg)]()
[![Language](https://img.shields.io/badge/language-Swift_5.0-orange.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()

**Last Update: 06/Apricl/2019.**

![](logo-hungry_wormy.png)

### If you like the project, please give it a star ⭐ It will show the creator your appreciation and help others to discover the repo.

# ✍️ About
🐛 `Hungry Wormy` is a retro game reincarnation implemented on top of SpriteKit framework for `iOS` & `macOS`.

# 📺 Demo
Please wait while the `.gif` files are loading...

<p align="center">
  <img src="Assets/Demo/Demo00.gif" width="870" />
</p>

<p float="left">
  <img src="Assets/Demo/Demo01.gif" width="288" /> 
  <img src="Assets/Demo/Demo02.gif" width="288" />
  <img src="Assets/Demo/Demo03.gif" width="288" />
</p>

# 🍱 Features
- Cross-platform: `macOS` & `iOS`. `tvOS` can be easily added as an update.
- `Extendable`, `data-driven` architecture: you can easily add a new level without any programming (well, almost 😄). 
- **Six** levels: from very trivial to insane difficulty level.
- Fully native implementation: `Swift` & `SpriteKit` only. 
- `One external` dependency.

# 📝 Controls

## iOS
On `iOS` all the controls are handled by `swipe` gestures. There are **4** gestures for swipe `up`, `left`, `down` and `right`. You will get the `haptic` feedback on the supported devices for when the `direction` of the `wormy` is changed. If you double swipe to a direction, the second swipe will be ignored.

## macOS
On `macOS` all the controls are handled by `arrow` keys. There are **4** keys for turning to `up ⬆️`, `left ⬅️`, `down ⬇️` and `right ➡️` directions. If you double tap to a direction, the second one will be ignored. In order to `pause/resume` the game you need to tap on `escape` key. 

# 🔗 Dependencies
The project currently has one dependency, which is [device-kit](https://github.com/jVirus/device-kit) framework.

# 🏗 How to create a new level
There is a possibility to create new levels, almost without any programming. Let's get started:

#### 1. Create a new `.sks` file:

<p float="left">
  <img src="Assets/Tutorial/01.png" width="400" />
  <img src="Assets/Tutorial/02.png" width="400" />
</p>

#### 2. Give it a name:

<p align="center">
  <img src="Assets/Tutorial/03.png" width="500" />
</p>

#### 3. Set the scene size to the following dimensions:

<p align="center">
  <img src="Assets/Tutorial/04.png" width="500" />
</p>

#### 4. Add **3** tile maps to the scene and set their properties as follows:

<p float="left">
  <img src="Assets/Tutorial/05.png" width="288" />
  <img src="Assets/Tutorial/06.png" width="288" />
  <img src="Assets/Tutorial/07.png" width="288" />
</p>

#### 5. Add a `Cover` node, copy-paste the `Pause` reference node and align everything as displayed in the following hierarchy:

<p align="center">
  <img src="Assets/Tutorial/08.png" width="500" />
</p>

#### 7.Start editing `Background` & `Walls` tile maps by drawing tiles as you'd like:

<p float="left">
  <img src="Assets/Tutorial/09.png" width="410" />
  <img src="Assets/Tutorial/10.png" width="410" />
</p>

<p float="left">
  <img src="Assets/Tutorial/11.png" width="410" />
  <img src="Assets/Tutorial/12.png" width="410" />
</p>

#### 8. Place the `blue` diamond tiles as `food` for `wormy` and `red` squares for spawn points:

<p align="center">
  <img src="Assets/Tutorial/13.png" width="500" />
</p>

#### 9. Add new button nodes to access the level:
In `Assets/Scenes/macOS/MainMenuScene-macOS.sks` & `Assets/Scenes/iOS/MainMenuScene-iOS.sks` files with custom `User Data` key/value pair that conforms to the following scheme: `levelName`:`YourLevelName.sks`. Remember that you need to set the corresponding `target membership` options in `File Inspector` menu for each of the `.sks` files.

#### 10. Done! 
You have written zero lines of code and added a new level to the game.
 
# 🖼 Assets
The game uses assets taken from [kenney.nl](https://kenney.nl) that are published under [CC0 1.0 Universal](https://creativecommons.org/publicdomain/zero/1.0/) licence.
 
# 👨‍💻 Author 
[Astemir Eleev](https://github.com/jVirus)

# 🔖 Licence
The project is available under [MIT licence](https://github.com/jVirus/hungry-wormy/blob/master/LICENSE)

[device-kit](https://github.com/jVirus/device-kit) framework is available under [MIT licence](https://github.com/jVirus/device-kit/blob/master/LICENSE)
