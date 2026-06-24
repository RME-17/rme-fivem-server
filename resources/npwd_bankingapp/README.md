# npwd_bankingapp

A banking app for [NPWD](https://github.com/project-error/new-phone-who-dis) built for QBox & QBcore servers. Designed with a BHRP (BeehiveRP) dark-orange theme and an alternative dark navy theme — both switchable in-app.

## Features

- **Bank & cash balance** — live balance card with gradient display
- **Transaction history** — reads from Renewed-Banking's `player_transactions` table (deposits, withdrawals, transfers in/out)
- **Phone-number transfers** — send money to any online player by their phone number
- **Account freeze indicator** — banner shown when the account is frozen
- **ATM locator** — sorted list of nearby ATM coordinates (configurable)
- **Theme switcher** — BHRP orange or dark navy, persisted via localStorage
- **Hide balance toggle** — privacy mode, also persisted

## Dependencies

| Resource | Notes |
|---|---|
| [qb-core](https://github.com/qbcore-framework/qb-core) | Core framework (Also works with QBox) |
| [npwd](https://github.com/project-error/new-phone-who-dis) | Phone UI host |
| [oxmysql](https://github.com/overextended/oxmysql) | Database queries |
| [Renewed-Banking](https://github.com/Renewed-Scripts/Renewed-Banking) | Transaction log source |

## Installation

1. Clone or download this repository into your `resources` folder:
   ```
   resources/npwd_bankingapp/
   ```

2. Add to your `server.cfg` **after** all dependencies:
   ```
   ensure npwd_bankingapp
   ```

3. Register the app in your NPWD config (`npwd.config.js` / `npwd.config.ts`):
   ```js
   import BankingApp from '@npwd/bankingapp'; // path varies by your NPWD setup
   ```
   Or add the remote entry URL to NPWD's app list — see the NPWD documentation for module federation app registration.

4. Restart your server or use `refresh` + `ensure npwd_bankingapp`.

> No SQL migration required — the app reads from Renewed-Banking's existing `player_transactions` table.

## Configuration

### Theme default

Edit `src/appConfig.ts` and change `BANKING_THEME` before building:

```ts
// 'bhrp' = dark orange  |  'default' = dark navy
export const BANKING_THEME: BankingThemeName = 'bhrp';
```

Players can also switch theme in-app via Settings.

### ATM locations

Edit the `ATM_COORDS` array in `client/client.ts` to match the actual ATM prop positions on your map.

## Building from source

Requires [Node.js](https://nodejs.org) ≥ 18 and [pnpm](https://pnpm.io).

```bash
pnpm install
pnpm build
```

This outputs:
- `dist/client.js` — client-side FiveM script
- `dist/server.js` — server-side FiveM script
- `web/dist/` — NUI React bundle

Pre-built files are committed to this repo so you can use it without building if you haven't changed the source.

## Project structure

```
npwd_bankingapp/
├── client/         # FiveM client script (NUI callbacks, ATM coords)
├── server/         # FiveM server script (QBCore callbacks, transfers)
├── src/            # React NUI app
│   ├── components/ # UI components
│   ├── hooks/      # useBanking hook
│   ├── atoms/      # Recoil state
│   ├── themes/     # CSS variable tokens
│   └── utils/      # fetchNui, currency formatting
├── dist/           # Built client & server scripts
├── web/dist/       # Built NUI bundle
└── fxmanifest.lua
```

## License

MIT
