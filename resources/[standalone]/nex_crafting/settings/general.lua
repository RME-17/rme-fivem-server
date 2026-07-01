--[[
    nex-Crafting | Config (hand-edited Lua)
    ONLY the settings a server owner actually changes live here.
    Reference data (prop catalog, access/bench types) lives in
    source/shared/definitions.lua; all text lives in locales/.
    Edit a value and restart the resource to apply it.
]]

nexCrafting = nexCrafting or {}

nexCrafting.ConfigData = {
    settings = {
        debug = true,

        -- UI theme. The panel is monochrome (black + one accent color).
        -- Set accentColor to any hex color to recolor the whole UI, e.g.
        -- '#FFFFFF' (white, default), '#E11D48' (red), '#F59E0B' (gold), '#3B82F6' (blue).
        theme = {
            accentColor = '#3B82F6',
        },

        commands = {
            creator = 'craftpanel',
            creatorAlias = 'crp',
        },

        permissions = {
            creatorAccess = {
                useAcePermission = true,
                acePermission = 'nex.crafting.creator',
                useFrameworkGroup = true,
                frameworkGroups = { 'admin', 'superadmin', 'god' },
            },
        },

        interaction = {
            -- NOTE (RME): useTarget is intentionally false. On this server nex_crafting's
            -- target bridge talks to qb-target in a format our qb-target build rejects
            -- ("@qb-target/client.lua:520: No trigger setup" on click). Marker interaction
            -- (walk up + press E) avoids the target system entirely and works reliably.
            useTarget = false,
            useMarker = true,
            interactionKey = 38,
            interactionDistance = 2,
            drawDistance = 10,
            markerType = 27,
            markerColor = { 255, 255, 255, 100 },
            markerSize = { 1, 1, 0.5 },
        },

        blips = {
            enabled = false,
            crafting = {
                sprite = 566,
                color = 2,
                scale = 0.7,
                display = 4,
            },
        },

        oxInventory = {
            imagePath = 'nui://qb-inventory/html/images/',
            benchStash = {
                enabled = false,
                slots = 10,
                weight = 50000,
            },
        },

        crafting = {
            -- Highest quantity a player may craft in a single batch from the
            -- expanded recipe window. The "craft x N" selector is also capped by
            -- how many materials the player is actually carrying.
            maxCraftAmount = 10,

            -- When true, a batch craft takes craftTime × quantity (crafting 5 at
            -- once feels like 5 crafts). Set false to keep batches near-instant.
            scaleCraftTimeWithAmount = true,

            skillCheck = {
                enabled = true,
                difficulty = 'easy',
                inputs = { 'w', 'a', 's', 'd' },
            },
            xpSystem = {
                enabled = false,
                xpPerCraft = 10,
                xpPerLevel = 100,
                maxLevel = 100,
                xpBonusOnLevelUp = 50,
            },
            failureSystem = {
                enabled = false,
                baseFailChance = 10,
                failChanceReduction = 0.5,
                loseItemsOnFail = true,
                losePercentOnFail = 50,
            },
            animations = {
                crafting = {
                    dict = 'mini@repair',
                    anim = 'fixing_a_player',
                    duration = 5000,
                },
            },
            sounds = {
                craftStart   = { set = 'ATM_SOUNDS', sound = 'PIN_BUTTON' },
                craftSuccess = { set = 'HUD_FRONTEND_DEFAULT_SOUNDSET', sound = 'PICK_UP' },
                craftFail    = { set = 'HUD_FRONTEND_DEFAULT_SOUNDSET', sound = 'ERROR' },
            },
        },
    },
}
