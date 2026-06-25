Config = {}

-- Chat command that opens the editor (gated by Config.Permission via qb-core).
Config.Command = 'mapper'

-- qb-core permission required to open the editor and mutate placements.
-- 'admin' or 'god'. Server-side events double-check this too.
Config.Permission = 'admin'

-- How far in front of you a freshly spawned prop appears (metres).
Config.SpawnDistance = 3.0

-- Selection ray length when aiming at a prop to edit/duplicate/delete (metres).
Config.RaycastDistance = 30.0

-- Default model pre-filled in the spawn dialog.
Config.DefaultModel = 'prop_barrel_01a'
