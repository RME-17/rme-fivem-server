# nex_crafting

Multi-framework crafting system for FiveM.
- **UI:** React + Tailwind (prebuilt, drop-in)
- **Frameworks:** ESX, QBox (qbx_core), QBCore (qb-core) — auto-detected
- **Stack:** ox_lib, oxmysql

## Installation (drag-and-drop)

1. Drop the `nex_crafting` folder into your resources.
2. Import `sql/install.sql` into your database.
3. (Optional) Edit `settings/general.lua` for your preferences,
   and `settings/discord.lua` if you want Discord-role-gated benches.
4. Add to `server.cfg`:
   ```cfg
   ensure ox_lib
   ensure oxmysql
   ensure ox_inventory
   ensure nex_crafting
   ```
5. In-game: `/craftpanel` (alias: `/crp`) to open the creator panel.
   Requires admin (`nex.crafting.creator` ACE or framework group
   `admin` / `superadmin` / `god`).

That's it. The UI is prebuilt and shipped in `web/build/`.

## Configuration

Everything you can change lives in `settings/general.lua`:
- Commands and aliases
- Skill check, XP, failure system
- Crafting animation + sounds
- Interaction (target / marker / distances)
- Map blips
- Permissions
- Prop models, bench types, access types
- All locale strings

You can edit by hand, or use the **Settings** tab in the creator UI —
the UI rewrites `settings/general.lua` so your changes persist across restarts.

Item-image path defaults to `nui://ox_inventory/web/images/`. If you use
a different inventory, change it in `settings/general.lua` →
`settings.oxInventory.imagePath` or in `integrations/client.lua`.

## Permissions

Open `settings/general.lua` → `settings.permissions.creatorAccess`:
- `useAcePermission = true` + `acePermission = 'nex.crafting.creator'`
- `useFrameworkGroup = true` + `frameworkGroups = { 'admin', 'superadmin', 'god' }`

## Discord-gated benches

Set `Config.Discord.botToken` and `Config.Discord.serverId` in
`settings/discord.lua`. Bot needs `GUILD_MEMBERS` intent.

## Exports (server)

- `exports.nex_crafting:GetBenches()` → array of benches
- `exports.nex_crafting:GetRecipeGroups()` → array of recipe groups
- `exports.nex_crafting:GetBench(id)` → bench or nil
- `exports.nex_crafting:HasBenchAccess(source, benchId)` → boolean
- `exports.nex_crafting:CraftForPlayer(source, benchId, recipeIndex, skillPassed?)`
