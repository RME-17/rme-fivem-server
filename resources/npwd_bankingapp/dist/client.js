(() => {
  // client/client.ts
  var QBCore = global.exports["qb-core"].GetCoreObject();
  var npwd = global.exports["npwd"];
  var ATM_COORDS = [
    { id: 1, name: "Legion Square", area: "Downtown LS", x: -1051.9, y: -774.4, z: 17 },
    { id: 2, name: "Pillbox Hill", area: "Medical Center", x: 299.5, y: -584.8, z: 43.3 },
    { id: 3, name: "Vinewood Blvd", area: "Vinewood", x: 157.3, y: -1019.5, z: 29.3 },
    { id: 4, name: "Little Seoul", area: "Little Seoul", x: -703.8, y: -912.8, z: 19.2 },
    { id: 5, name: "Strawberry Ave", area: "Strawberry", x: -786.3, y: -1280.6, z: 17.3 },
    { id: 6, name: "Del Perro Pier", area: "Del Perro", x: -2963.1, y: 479.6, z: 15.7 },
    { id: 7, name: "LSIA Terminal", area: "Airport", x: -1034.5, y: -2726, z: 20.2 },
    { id: 8, name: "Vespucci Beach", area: "Vespucci", x: -1213.4, y: -330.4, z: 37.8 },
    { id: 9, name: "Mirror Park", area: "East LS", x: 1149.5, y: -474.4, z: 67.5 },
    { id: 10, name: "Rockford Hills", area: "Rockford Hills", x: -178.9, y: 499.9, z: 111.8 },
    { id: 11, name: "Sandy Shores", area: "Sandy Shores", x: 1827.6, y: 3695.6, z: 34.3 },
    { id: 12, name: "Paleto Bay", area: "Paleto Bay", x: -101.7, y: 6469.3, z: 31.6 }
  ];
  RegisterNuiCallbackType("getBalance");
  on("__cfx_nui:getBalance", (_data, cb) => {
    QBCore.Functions.TriggerCallback("bankingapp:getBalance", (resp) => cb(resp));
  });
  RegisterNuiCallbackType("getTransactions");
  on("__cfx_nui:getTransactions", (_data, cb) => {
    QBCore.Functions.TriggerCallback("bankingapp:getTransactions", (resp) => cb(resp));
  });
  RegisterNuiCallbackType("getPlayerByPhone");
  on("__cfx_nui:getPlayerByPhone", (data, cb) => {
    QBCore.Functions.TriggerCallback("bankingapp:getPlayerByPhone", (resp) => cb(resp), data.phoneNumber);
  });
  RegisterNuiCallbackType("transfer");
  on("__cfx_nui:transfer", (data, cb) => {
    QBCore.Functions.TriggerCallback("bankingapp:transfer", (resp) => cb(resp), data);
  });
  RegisterNuiCallbackType("getAtmLocations");
  on("__cfx_nui:getAtmLocations", (_data, cb) => {
    const ped = PlayerPedId();
    const coords = GetEntityCoords(ped, false);
    const [px, py, pz] = [coords[0], coords[1], coords[2]];
    const locations = ATM_COORDS.map((atm) => {
      const dx = atm.x - px;
      const dy = atm.y - py;
      const dz = atm.z - pz;
      return { id: atm.id, name: atm.name, area: atm.area, distance: Math.round(Math.sqrt(dx * dx + dy * dy + dz * dz)) };
    }).sort((a, b) => a.distance - b.distance);
    cb({ ok: true, data: locations });
  });
  onNet("bankingapp:client:incomingTransfer", (data) => {
    npwd.sendNPWDMessage("BANKING_APP", "incomingTransfer", data);
  });
})();
