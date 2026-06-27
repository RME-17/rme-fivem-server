# Fetchq Oil Rig Job

A highly advanced and synchronized multiplayer Oil Rig job for FiveM. Designed to give your players an immersive experience with tugboats, helicopters, and heavy lifting!

## 🚀 Features
- **Multiplayer Squad Support**: Players can do the job together, and progress is fully synchronized.
- **Dynamic Missions**: Work with tugboats and helicopters to transport oil containers.
- **Framework Agnostic**: Works flawlessly with **ESX** and **QB-Core**.
- **Highly Configurable**: Easily tweak boat speeds, rewards, and spawn locations in `shared/config.lua`.
- **Target System Support**: Compatible with `ox_target`, `qb-target`, and `interact`.
- **Inventory Support**: Supports `ox_inventory`, `qs-inventory`, `codem-inventory`, and `esx_inventoryhud`.

## 📦 Dependencies
Ensure you have the following resources installed and started *before* this script:
- [ox_lib](https://github.com/overextended/ox_lib)
- A supported framework (ESX or QB-Core)
- A supported target system (ox_target / qb-target)

## 🛠️ Installation

1. Download the resource and extract it.
2. Drag and drop the `fetchq-oil` folder into your `resources` directory.
3. Open your `server.cfg` and add the following line:
   ```cfg
   ensure fetchq-oil
   ```
   *(Make sure to put it below your framework and dependencies like `ox_lib`)*
4. Open `shared/config.lua` and adjust the settings according to your server's needs (Framework, Language, Rewards, etc.).
5. Start your server and enjoy!

## ⚙️ Configuration
The script is heavily customizable via `shared/config.lua`. You can modify:
- **CoreName**: Set to `"es_extended"` for ESX, `"qb-core"` for QB, or `"auto"`.
- **Boat Performance**: Modify the speed, torque, and max speed of the mission tugboats to make journeys faster.
- **Rewards**: Adjust minimum and maximum payouts for missions.
- **Language**: Change the `Locale` setting in `locales/locale.lua` to your preferred language (en, de, es, fr, pt, pl).

## 🐛 Troubleshooting
- **Boats Spawning Flipped**: Ensure the spawn locations defined in the config are clear of any large map objects or piers.
- **Framework Not Detected**: If the script does not load your framework automatically, manually set `CoreName` in `shared/config.lua`.
