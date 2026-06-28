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

## Blueprints

Any recipe can be locked behind a **blueprint**. In the creator's recipe editor,
tick **Require Blueprint**, pick the blueprint item, and choose whether it's
consumed on learn:

- A blueprint-gated recipe is hidden behind a lock at the bench until the player
  **learns** it.
- To learn, the player must be **holding the blueprint item**, then press
  **Learn** on the recipe. The blueprint is consumed (unless you turned that off)
  and the unlock is saved per-character — it survives relogs and recipe edits.
- Crafting is enforced server-side: a player who hasn't learned the recipe can't
  craft it even with a tampered UI.

Learned recipes are stored in `nex_crafting_player_blueprints` (keyed by the
recipe's item name). The schema auto-installs and self-heals on resource start —
**no manual SQL needed** when upgrading; just restart the resource.

**Optional — "use" a blueprint item from the inventory.** To let players unlock
by *using* the item anywhere (not just at a bench), make it a usable ox_inventory
item in `ox_inventory/data/items.lua`:

```lua
['blueprint_pistol'] = {
    label = 'Pistol Blueprint', weight = 100, stack = true, consume = 1,
    server = { export = 'nex_crafting.UseBlueprintItem' },
}
```

It unlocks every recipe gated by that item name and is consumed only when it
actually taught the player something new.

## Localization & item labels

- The interaction prompt ("Use <bench>") is fully localized — add/adjust the
  `useBench` key in `locales/<lang>.lua` and set `nexCrafting.Language` in
  `settings/runtime.lua`.
- Ingredient/result names in the bench UI show the **ox_inventory labels** for
  each item, falling back to the raw item name if it isn't registered.

## Exports (server)

- `exports.nex_crafting:GetBenches()` → array of benches
- `exports.nex_crafting:GetRecipeGroups()` → array of recipe groups
- `exports.nex_crafting:GetBench(id)` → bench or nil
- `exports.nex_crafting:HasBenchAccess(source, benchId)` → boolean
- `exports.nex_crafting:CraftForPlayer(source, benchId, recipeIndex, skillPassed?)`
- `exports.nex_crafting:HasLearnedRecipe(source, recipeName)` → boolean
- `exports.nex_crafting:GetLearnedRecipes(source)` → array of recipe names
- `exports.nex_crafting:LearnBlueprintItem(source, blueprintItem)` → number learned
- `exports.nex_crafting:UseBlueprintItem(...)` — ox_inventory usable-item hook
