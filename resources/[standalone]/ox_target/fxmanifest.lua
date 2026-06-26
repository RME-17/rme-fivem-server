fx_version 'cerulean'
game 'gta5'

name 'ox_target'
description 'ox_target -> qb-target compatibility shim (RME). Routes ox_target export calls into qb-target so the whole server runs one targeting system on one key (Left Alt). Registers NO keybind/eye of its own.'
author 'RME'
version '1.0.0'

-- IMPORTANT: This is NOT the real ox_target. It is a thin compatibility layer
-- so nex_crafting (which hard-calls exports.ox_target:addLocalEntity) works on
-- qb-target without a second targeting eye/keybind. Do not install the real
-- ox_target alongside this, or the dual-eye conflict returns.

client_script 'client.lua'
