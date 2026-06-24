// server/server.ts  — adapted for qb-banking (bank_statements + CreateBankStatement)
var QBCore = global.exports["qb-core"].GetCoreObject();
var oxmysql = global.exports["oxmysql"];
var qbBanking = global.exports["qb-banking"];
function getPlayer(src) {
  return QBCore.Functions.GetPlayer(src);
}
function allOnlinePlayers() {
  return QBCore.Functions.GetQBPlayers();
}
function playerByPhone(phone) {
  const players = allOnlinePlayers();
  for (const id in players) {
    const p = players[id];
    if (p?.PlayerData?.charinfo?.phone === phone)
      return p;
  }
  return null;
}
function fullName(p) {
  const { firstname, lastname } = p.PlayerData.charinfo;
  return `${firstname} ${lastname}`;
}
function logStatement(playerId, amount, reason, statementType) {
  try {
    qbBanking.CreateBankStatement(playerId, "checking", amount, reason, statementType, "player");
  } catch (e) {
    console.log("[npwd_bankingapp] CreateBankStatement failed:", e);
  }
}
QBCore.Functions.CreateCallback(
  "bankingapp:getBalance",
  (src, cb) => {
    const player = getPlayer(src);
    if (!player)
      return cb({ ok: false, error: "Player not found" });
    cb({
      ok: true,
      data: {
        bank: player.PlayerData.money.bank,
        cash: player.PlayerData.money.cash,
        citizenid: player.PlayerData.citizenid
      }
    });
  }
);
QBCore.Functions.CreateCallback(
  "bankingapp:getTransactions",
  (src, cb) => {
    const player = getPlayer(src);
    if (!player)
      return cb({ ok: false, error: "Player not found" });
    const citizenid = player.PlayerData.citizenid;
    oxmysql.execute(
      "SELECT amount, reason, statement_type, date FROM bank_statements WHERE citizenid = ? ORDER BY id DESC LIMIT 50",
      [citizenid],
      (rows) => {
        if (!rows || rows.length === 0)
          return cb({ ok: true, data: [] });
        const txs = rows.map((row, i) => {
          const rawType = (row.statement_type ?? "").toLowerCase();
          const reason = row.reason || "";
          let type;
          let other_party = null;
          if (rawType === "withdraw") {
            if (/transfer to/i.test(reason)) {
              type = "transfer_out";
              other_party = null;
            } else {
              type = "withdrawal";
            }
          } else {
            if (/transfer from/i.test(reason)) {
              type = "transfer_in";
              other_party = null;
            } else {
              type = "deposit";
            }
          }
          let ts;
          try {
            ts = row.date ? new Date(row.date).toISOString() : new Date().toISOString();
          } catch {
            ts = new Date().toISOString();
          }
          return {
            id: i + 1,
            type,
            amount: Math.abs(row.amount ?? 0),
            description: reason || type,
            other_party,
            timestamp: ts
          };
        });
        cb({ ok: true, data: txs });
      }
    );
  }
);
QBCore.Functions.CreateCallback(
  "bankingapp:getPlayerByPhone",
  (src, cb, phoneNumber) => {
    const recipient = playerByPhone(phoneNumber);
    if (!recipient)
      return cb({ ok: false, error: "No online player with that phone number" });
    cb({ ok: true, data: { name: fullName(recipient) } });
  }
);
QBCore.Functions.CreateCallback(
  "bankingapp:transfer",
  (src, cb, payload) => {
    const sender = getPlayer(src);
    if (!sender)
      return cb({ ok: false, error: "Player not found" });
    const sanitized = Math.floor(payload.amount);
    if (sanitized <= 0)
      return cb({ ok: false, error: "Amount must be greater than 0" });
    if (sender.PlayerData.money.bank < sanitized)
      return cb({ ok: false, error: "Insufficient bank balance" });
    const recipient = playerByPhone(payload.phoneNumber);
    if (!recipient)
      return cb({ ok: false, error: "Recipient not found or offline" });
    if (recipient.PlayerData.citizenid === sender.PlayerData.citizenid)
      return cb({ ok: false, error: "Cannot transfer to yourself" });
    const senderName = fullName(sender);
    const recipientName = fullName(recipient);
    sender.Functions.RemoveMoney("bank", sanitized, "bankingapp-transfer-out");
    recipient.Functions.AddMoney("bank", sanitized, "bankingapp-transfer-in");
    emitNet("bankingapp:client:incomingTransfer", recipient.PlayerData.source, { amount: sanitized, from: senderName });
    cb({ ok: true, data: { bank: sender.PlayerData.money.bank, cash: sender.PlayerData.money.cash } });
    logStatement(sender.PlayerData.source, sanitized, `Transfer to ${recipientName}`, "withdraw");
    logStatement(recipient.PlayerData.source, sanitized, `Transfer from ${senderName}`, "deposit");
  }
);
QBCore.Functions.CreateCallback(
  "bankingapp:deposit",
  (src, cb, amount) => {
    const player = getPlayer(src);
    if (!player)
      return cb({ ok: false, error: "Player not found" });
    const sanitized = Math.floor(amount);
    if (sanitized <= 0)
      return cb({ ok: false, error: "Amount must be greater than 0" });
    if (player.PlayerData.money.cash < sanitized)
      return cb({ ok: false, error: "Insufficient cash" });
    player.Functions.RemoveMoney("cash", sanitized, "bankingapp-deposit");
    player.Functions.AddMoney("bank", sanitized, "bankingapp-deposit");
    logStatement(player.PlayerData.source, sanitized, "Phone deposit", "deposit");
    cb({ ok: true, data: { bank: player.PlayerData.money.bank, cash: player.PlayerData.money.cash } });
  }
);
QBCore.Functions.CreateCallback(
  "bankingapp:withdraw",
  (src, cb, amount) => {
    const player = getPlayer(src);
    if (!player)
      return cb({ ok: false, error: "Player not found" });
    const sanitized = Math.floor(amount);
    if (sanitized <= 0)
      return cb({ ok: false, error: "Amount must be greater than 0" });
    if (player.PlayerData.money.bank < sanitized)
      return cb({ ok: false, error: "Insufficient bank balance" });
    player.Functions.RemoveMoney("bank", sanitized, "bankingapp-withdraw");
    player.Functions.AddMoney("cash", sanitized, "bankingapp-withdraw");
    logStatement(player.PlayerData.source, sanitized, "Phone withdrawal", "withdraw");
    cb({ ok: true, data: { bank: player.PlayerData.money.bank, cash: player.PlayerData.money.cash } });
  }
);
