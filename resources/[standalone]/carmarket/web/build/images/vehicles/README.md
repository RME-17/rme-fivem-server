# Custom vehicle images

Drop `<respname>.webp` files here for any modded/custom vehicle whose image
isn't on `docs.fivem.net`.

After adding a file, register the respname in `shared/config.lua`:

```lua
Config.CustomVehicleImages = {
    'mymodcar1',
    'mymodcar2',
}
```

Respname must be **lowercase** and match the vehicle's spawn model exactly.

Recommended format: **512×256 WebP, transparent background**.

After adding/changing files, rebuild the frontend (`cd web && bun run build`)
so the file ends up in `web/build/images/vehicles/`.
