/// <reference types="@citizenfx/server" />

const QBCore  = (global.exports as any)['qb-core'].GetCoreObject();
const oxmysql = (global.exports as any)['oxmysql'];

// ── Types ─────────────────────────────────────────────────────────────────────

interface Transaction {
  id: number;
  type: 'deposit' | 'withdrawal' | 'transfer_in' | 'transfer_out';
  amount: number;
  description: string;
  other_party: string | null;
  timestamp: string;
}

type NuiResp<T = undefined> =
  | { ok: true; data: T }
  | { ok: false; error: string };

// ── Helpers ───────────────────────────────────────────────────────────────────

function getPlayer(src: number) { return QBCore.Functions.GetPlayer(src) as any; }

function allOnlinePlayers(): Record<string, any> {
  return QBCore.Functions.GetQBPlayers() as Record<string, any>;
}

function playerByPhone(phone: string): any | null {
  const players = allOnlinePlayers();
  for (const id in players) {
    const p = players[id];
    if (p?.PlayerData?.charinfo?.phone === phone) return p;
  }
  return null;
}

function fullName(p: any): string {
  const { firstname, lastname } = p.PlayerData.charinfo;
  return `${firstname} ${lastname}`;
}

// ── getBalance ────────────────────────────────────────────────────────────────

QBCore.Functions.CreateCallback(
  'bankingapp:getBalance',
  (src: number, cb: (r: NuiResp<{ bank: number; cash: number; citizenid: string }>) => void) => {
    const player = getPlayer(src);
    if (!player) return cb({ ok: false, error: 'Player not found' });
    cb({
      ok: true,
      data: {
        bank:      player.PlayerData.money.bank,
        cash:      player.PlayerData.money.cash,
        citizenid: player.PlayerData.citizenid,
      },
    });
  },
);

// ── getTransactions — reads from Renewed-Banking player_transactions table ────
// Renewed-Banking stores transactions as a JSON array in player_transactions.transactions
// Each entry: { trans_id, title, amount, trans_type, receiver, message, issuer, time }
// trans_type: 'deposit' | 'withdraw'  (transfers appear as withdraw on sender, deposit on receiver)
// A withdraw/deposit is a transfer when issuer !== receiver

QBCore.Functions.CreateCallback(
  'bankingapp:getTransactions',
  (src: number, cb: (r: NuiResp<Transaction[]>) => void) => {
    const player = getPlayer(src);
    if (!player) return cb({ ok: false, error: 'Player not found' });

    const citizenid: string = player.PlayerData.citizenid;

    oxmysql.execute(
      'SELECT transactions FROM player_transactions WHERE id = ?',
      [citizenid],
      (rows: any[]) => {
        if (!rows || rows.length === 0) return cb({ ok: true, data: [] });

        const raw: string = rows[0].transactions;
        if (!raw) return cb({ ok: true, data: [] });

        let entries: any[];
        try { entries = JSON.parse(raw); } catch { return cb({ ok: true, data: [] }); }
        if (!Array.isArray(entries)) return cb({ ok: true, data: [] });

        const txs: Transaction[] = entries.slice(0, 50).map((entry: any, i: number) => {
          const rawType: string = (entry.trans_type ?? '').toLowerCase();
          const hasOtherParty = entry.issuer && entry.receiver && entry.issuer !== entry.receiver;

          let type: Transaction['type'];
          let other_party: string | null = null;

          if (rawType === 'withdraw') {
            if (hasOtherParty) {
              type = 'transfer_out';
              other_party = entry.receiver ?? null;
            } else {
              type = 'withdrawal';
            }
          } else if (rawType === 'deposit') {
            if (hasOtherParty) {
              type = 'transfer_in';
              other_party = entry.issuer ?? null;
            } else {
              type = 'deposit';
            }
          } else {
            type = 'deposit';
          }

          return {
            id:          i + 1,
            type,
            amount:      Math.abs(entry.amount ?? 0),
            description: entry.message || entry.title || type,
            other_party,
            timestamp:   new Date((entry.time ?? 0) * 1000).toISOString(),
          };
        });

        cb({ ok: true, data: txs });
      },
    );
  },
);

// ── getPlayerByPhone ──────────────────────────────────────────────────────────

QBCore.Functions.CreateCallback(
  'bankingapp:getPlayerByPhone',
  (src: number, cb: (r: NuiResp<{ name: string }>) => void, phoneNumber: string) => {
    const recipient = playerByPhone(phoneNumber);
    if (!recipient) return cb({ ok: false, error: 'No online player with that phone number' });
    cb({ ok: true, data: { name: fullName(recipient) } });
  },
);

// ── transfer ──────────────────────────────────────────────────────────────────

QBCore.Functions.CreateCallback(
  'bankingapp:transfer',
  (src: number, cb: (r: NuiResp<{ bank: number; cash: number }>) => void, payload: { phoneNumber: string; amount: number }) => {
    const sender = getPlayer(src);
    if (!sender) return cb({ ok: false, error: 'Player not found' });

    const sanitized = Math.floor(payload.amount);
    if (sanitized <= 0)                           return cb({ ok: false, error: 'Amount must be greater than 0' });
    if (sender.PlayerData.money.bank < sanitized) return cb({ ok: false, error: 'Insufficient bank balance' });

    const recipient = playerByPhone(payload.phoneNumber);
    if (!recipient) return cb({ ok: false, error: 'Recipient not found or offline' });
    if (recipient.PlayerData.citizenid === sender.PlayerData.citizenid)
      return cb({ ok: false, error: 'Cannot transfer to yourself' });

    const senderName    = fullName(sender);
    const recipientName = fullName(recipient);

    sender.Functions.RemoveMoney('bank', sanitized, 'bankingapp-transfer-out');
    recipient.Functions.AddMoney('bank', sanitized, 'bankingapp-transfer-in');

    emitNet('bankingapp:client:incomingTransfer', recipient.PlayerData.source, { amount: sanitized, from: senderName });

    cb({ ok: true, data: { bank: sender.PlayerData.money.bank, cash: sender.PlayerData.money.cash } });

    // Log via Renewed-Banking so it appears in both apps and the in-memory cache stays consistent
    const renewedBanking = (global.exports as any)['Renewed-Banking'];
    renewedBanking.handleTransaction(
      sender.PlayerData.citizenid,
      `Personal Account`,
      sanitized,
      `Transfer to ${recipientName}`,
      senderName,
      recipientName,
      'withdraw',
    );
    renewedBanking.handleTransaction(
      recipient.PlayerData.citizenid,
      `Personal Account`,
      sanitized,
      `Transfer from ${senderName}`,
      senderName,
      recipientName,
      'deposit',
    );
  },
);

// ── deposit / withdraw (kept for ATM compatibility) ───────────────────────────

QBCore.Functions.CreateCallback(
  'bankingapp:deposit',
  (src: number, cb: (r: NuiResp<{ bank: number; cash: number }>) => void, amount: number) => {
    const player = getPlayer(src);
    if (!player) return cb({ ok: false, error: 'Player not found' });
    const sanitized = Math.floor(amount);
    if (sanitized <= 0)                             return cb({ ok: false, error: 'Amount must be greater than 0' });
    if (player.PlayerData.money.cash < sanitized)   return cb({ ok: false, error: 'Insufficient cash' });
    player.Functions.RemoveMoney('cash', sanitized, 'bankingapp-deposit');
    player.Functions.AddMoney('bank', sanitized, 'bankingapp-deposit');
    cb({ ok: true, data: { bank: player.PlayerData.money.bank, cash: player.PlayerData.money.cash } });
  },
);

QBCore.Functions.CreateCallback(
  'bankingapp:withdraw',
  (src: number, cb: (r: NuiResp<{ bank: number; cash: number }>) => void, amount: number) => {
    const player = getPlayer(src);
    if (!player) return cb({ ok: false, error: 'Player not found' });
    const sanitized = Math.floor(amount);
    if (sanitized <= 0)                             return cb({ ok: false, error: 'Amount must be greater than 0' });
    if (player.PlayerData.money.bank < sanitized)   return cb({ ok: false, error: 'Insufficient bank balance' });
    player.Functions.RemoveMoney('bank', sanitized, 'bankingapp-withdraw');
    player.Functions.AddMoney('cash', sanitized, 'bankingapp-withdraw');
    cb({ ok: true, data: { bank: player.PlayerData.money.bank, cash: player.PlayerData.money.cash } });
  },
);
