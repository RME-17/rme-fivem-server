# Moving Company FiveM Resource

Players talk to a moving company NPC, accept a moving contract, get a Boxville van, load furniture/boxes at the depot, deliver everything to a customer, then return to collect payment.

## Install

1. Move or keep this folder inside your server resources.
2. Add this to `server.cfg`:

```cfg
ensure moving_company
```

3. Restart the server.

## Framework

Set `Config.Framework` in `shared/config.lua`.

- `auto`: detects QBCore, then ESX, then standalone
- `qb`: QBCore payment
- `esx`: ESX payment
- `standalone`: job works, but only shows a completion notification

Payment values, NPC location, vehicle model, items, and delivery addresses are all editable in `shared/config.lua`.

## Notifications

Set `Config.Notifications.system` in `shared/config.lua` to choose the notification resource:

- `auto`: detects the first started provider in `autoPriority`
- `okokNotify`
- `brutal_notify`
- `wasabi_notify`
- `mythic_notify`
- `ox_lib`
- `qb`
- `esx`
- `gta`: built-in GTA notification feed
- `custom`: runs the editable custom callback

For example, to always use okokNotify:

```lua
Config.Notifications.system = 'okokNotify'
```

`autoPriority` can be reordered to decide which notification resource wins when multiple supported systems are running. `duration`, `titleKey`, and `playSound` configure the shared notification appearance where the selected provider supports those options.

To connect another notification script, select `custom` and edit the callback:

```lua
Config.Notifications.system = 'custom'

Config.Notifications.custom = function(message, notifyType, duration, title)
    exports['your_notify']:Notify(title, message, duration, notifyType)
    return true
end
```

The custom callback receives normalized `info`, `success`, `warning`, or `error` types. Return `false` if the script should fall back to the built-in GTA notification.

## Fuel Systems

Set `Config.Integrations.fuel` in `shared/config.lua` to choose the moving truck's fuel provider:

- `auto`: detects the first started provider in `fuelAutoPriority`
- `lc_fuel`
- `Renewed-Fuel`
- `LegacyFuel`
- `ps-fuel`
- `lj-fuel`
- `cdn-fuel`
- `x-fuel`
- `ox_fuel`
- `native`: GTA vehicle fuel level only
- `custom`: runs the editable custom fuel callback
- `none`: does not set the truck's fuel

For example, to always use LC Fuel:

```lua
Config.Integrations.fuel = 'lc_fuel'
Config.Integrations.startFuel = 100.0
Config.Integrations.fuelType = nil
```

LC Fuel supports `electric`, `regular`, `midgrade`, `premium`, and `diesel` fuel types. Leave `fuelType = nil` to let LC Fuel select the vehicle model's configured type.

`fuelAutoPriority` can be reordered when multiple fuel resources are installed. The script always sets GTA's native vehicle fuel level as a fallback before updating the selected external provider.

To connect another fuel resource:

```lua
Config.Integrations.fuel = 'custom'

Config.Integrations.customFuel = function(vehicle, amount, fuelType)
    exports['your_fuel']:SetFuel(vehicle, amount)
    return true
end
```

Return `false` if the custom resource did not handle the request. The native GTA fuel level will remain applied.

## Languages

The resource includes complete locale packs for:

- English (`en`)
- French (`fr`)
- Spanish (`es`)
- German (`de`)
- Italian (`it`)
- Portuguese (`pt`)

`Config.Locale = 'auto'` is enabled by default. Each player sees the script in the language selected by their GTA/FiveM client, so players in the same crew can use different languages at the same time.

To force one language for everyone, change the setting in `shared/config.lua`:

```lua
Config.Locale = 'fr'
```

Use `Config.FallbackLocale = 'en'` to choose the language used when a player's detected language does not have a locale pack.

All player-facing text is stored in `locales/*.lua`, including menus, target labels, notifications, progress bars, routes, item names, destination names, and interaction prompts. Copy `locales/en.lua`, rename the locale code, and translate its values to add another language. Keep every translation key and formatting placeholder such as `%s` or `%.0f`.

Each entry in `Config.Destinations` has:

- `door`: the building entrance reference point
- `arrival`: the exterior point used for the truck route and nearby-vehicle check

`Config.DeliveryPlacement.spots` defines seven exterior doorstep positions. Each spot is calculated from the door toward the arrival point, then spread left, right, and into a second row. Delivered props stay at their assigned positions instead of stacking into one pile or appearing inside the building.

- `forward` moves a placement spot away from the door.
- Positive and negative `side` values move spots to opposite sides of the doorstep.
- A destination can still define a custom `dropoffs` table when a building needs fully manual coordinates.

## Job Outfits

`Config.Outfit` automatically equips separate male and female moving uniforms when a job begins. The player's original clothing and props are saved and restored when the job is completed, canceled, or the resource stops.

- Set `enabled = false` to disable job uniforms.
- Set `restoreAfterJob = false` to leave the uniform equipped afterward.
- Edit `male.components`, `female.components`, and their `props` tables to use clothing from your server.
- Components `3`, `8`, and `11` form the matched orange/yellow high-visibility worker outfit.
- Component `9` is cleared so tactical body armor is not shown.
- The configured vest is cosmetic and does not grant gameplay armor.
- Job outfits apply to the standard `mp_m_freemode_01` and `mp_f_freemode_01` player models.

## Cargo Layout

Small cargo marked with `cargoType = 'bench'` uses the left and right side benches in the truck. Boxes and the TV are rotated sideways and packed independently from chairs and tables, which continue to use the floor slots.

- Edit `Config.Vehicle.benchSlots` to tune side-bench offsets and rotations.
- Edit `Config.Vehicle.cargoSlots` to tune furniture floor positions.
- `Config.Animations.pickup` controls the low bending pickup animation.

## Folder Layout

- `fxmanifest.lua`: resource manifest and load order
- `shared/config.lua`: editable settings, locations, props, payouts, locale selection, and integrations
- `shared/localization.lua`: locale detection, fallback behavior, and translation helpers
- `locales/*.lua`: editable language packs
- `client/notifications.lua`: notification provider adapter and fallback behavior
- `client/fuel.lua`: fuel provider detection, exports, and native fallback
- `client/main.lua`: client gameplay, UI, targets, markers, props, vehicle behavior, and routes
- `server/main.lua`: job validation, crews, payouts, cooldowns, and anti-exploit checks
- `docs/README.md`: setup notes and controls

## Optional Dependencies

- `ox_lib`: contract context menu, notifications, and progress circles when available
- `okokNotify`, `brutal_notify`, `wasabi_notify`, or `mythic_notify`: optional notification providers
- `ox_target` or `qb-target`: target interaction on the moving company NPC
- `qb-vehiclekeys` or `qs-vehiclekeys`: automatic moving truck keys
- `lc_fuel`, `Renewed-Fuel`, `LegacyFuel`, `ps-fuel`, `lj-fuel`, `cdn-fuel`, `x-fuel`, or `ox_fuel`: automatic truck fuel setup

The script still has fallbacks for most optional integrations, but `ox_lib` is currently enabled in `fxmanifest.lua`. Start `ox_lib` before this resource.

Targeting is enabled by default in `Config.Target`. Use `system = 'auto'` to prefer `ox_target` and fall back to `qb-target`. Set `fallbackPressE = true` if you want the old boss `[E]` prompt to appear when no target script is running.

## Security

The server validates job state, item sequence, vehicle net ID, depot/delivery distance, action cooldowns, and final payout. Clients only request actions; the server owns contract progress and payout.

## Crew Jobs

Use the contract menu's crew option to create or join a shared moving job.

- `Create Crew`: creates a lobby with a short code the leader can give to other players
- `Join By Code`: lets a player enter the leader's code
- `Invite Movers`: opens a nearby-player dropdown
- `Invite All Nearby`: sends an invite to every available nearby player
- `Start`: leader-only button that starts the job with the current lobby members

Players who receive an invite must accept it before they join. Set crew size, code length, invite radius, invite expiry, and payout split in `Config.Crew`.

## Controls

- Target the moving boss: view contracts, cancel job, or finish after delivery
- `E` at the depot marker: pick up the next furniture/box
- `E` at the back of the truck: place the item in the truck
- `E` at the back of the truck during delivery: open the truck doors, then take the next item out
- `E` at the customer marker while carrying: place the item down
- `Shift + E` at the boss while on a job: cancel job
