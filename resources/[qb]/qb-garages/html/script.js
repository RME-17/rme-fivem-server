window.addEventListener("message", function (event) {
    const data = event.data;
    if (data.action === "VehicleList") {
        const garageLabel = data.garageLabel;
        const vehicles = data.vehicles;
        populateVehicleList(garageLabel, vehicles);
        displayUI();
    }
});

document.addEventListener("keydown", function (event) {
    if (event.key === "Escape") {
        closeGarageMenu();
    }
});

function closeGarageMenu() {
    const container = document.querySelector(".container");
    container.style.display = "none";
    postNui("closeGarage", {});
}

function displayUI() {
    const container = document.querySelector(".container");
    container.style.display = "block";
}

function postNui(endpoint, payload) {
    return fetch(`https://qb-garages/${endpoint}`, {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify(payload),
    })
        .then((response) => response.json())
        .catch(() => {});
}

// RME: builds the slide-down transfer panel shared by both card types.
// includeGarage = also offer the "To Garage" (move-here) action.
function buildTransferPanel(v, includeGarage) {
    const panel = document.createElement("div");
    panel.classList.add("transfer-panel");

    if (includeGarage) {
        const toGarage = document.createElement("button");
        toGarage.classList.add("drive-btn", "btn-transfer");
        toGarage.textContent = "To Garage \u00B7 $200";
        toGarage.onclick = function () {
            if (toGarage.disabled) return;
            toGarage.disabled = true;
            toGarage.textContent = "Transferring...";
            postNui("transferVehicle", { plate: v.plate, index: v.index });
        };
        panel.appendChild(toGarage);
    }

    const playerRow = document.createElement("div");
    playerRow.classList.add("transfer-player-row");

    const input = document.createElement("input");
    input.type = "number";
    input.min = "1";
    input.classList.add("transfer-input");
    input.placeholder = "Player ID";
    playerRow.appendChild(input);

    const toPlayer = document.createElement("button");
    toPlayer.classList.add("drive-btn", "btn-transfer");
    toPlayer.textContent = "To Player";
    toPlayer.onclick = function () {
        if (toPlayer.disabled) return;
        const targetId = parseInt(input.value, 10);
        if (!targetId || targetId < 1) {
            input.classList.add("input-error");
            input.focus();
            return;
        }
        toPlayer.disabled = true;
        toPlayer.textContent = "Sending...";
        postNui("transferVehicleToPlayer", { plate: v.plate, targetId: targetId });
    };
    playerRow.appendChild(toPlayer);

    panel.appendChild(playerRow);
    return panel;
}

function makeTransferToggle(panel) {
    const toggle = document.createElement("button");
    toggle.classList.add("drive-btn", "btn-transfer");
    toggle.textContent = "Transfer";
    toggle.onclick = function () {
        panel.classList.toggle("open");
    };
    return toggle;
}

function populateVehicleList(garageLabel, vehicles) {
    const vehicleContainerElem = document.querySelector(".vehicle-table");
    const fragment = document.createDocumentFragment();

    while (vehicleContainerElem.firstChild) {
        vehicleContainerElem.removeChild(vehicleContainerElem.firstChild);
    }

    const garageHeader = document.getElementById("garage-header");
    garageHeader.textContent = garageLabel;

    vehicles.forEach((v) => {
        const vehicleItem = document.createElement("div");
        vehicleItem.classList.add("vehicle-item");
        let panelEl = null;

        // Vehicle Info: Name, Plate & Mileage
        const vehicleInfo = document.createElement("div");
        vehicleInfo.classList.add("vehicle-info");

        const vehicleName = document.createElement("span");
        vehicleName.classList.add("vehicle-name");
        vehicleName.textContent = v.vehicleLabel;
        vehicleInfo.appendChild(vehicleName);

        const plate = document.createElement("span");
        plate.classList.add("plate");
        plate.textContent = v.plate;
        vehicleInfo.appendChild(plate);

        const mileage = document.createElement("span");
        mileage.classList.add("mileage");
        mileage.textContent = `${v.distance}mi`;
        vehicleInfo.appendChild(mileage);

        vehicleItem.appendChild(vehicleInfo);

        const financeDriveContainer = document.createElement("div");
        financeDriveContainer.classList.add("finance-drive-container");

        if (v.transferable) {
            // Vehicle is stored at a different garage.
            const parkedInfo = document.createElement("div");
            parkedInfo.classList.add("finance-info", "status-elsewhere");
            parkedInfo.textContent = "AT " + String(v.parkedLabel || "ANOTHER GARAGE").toUpperCase();
            financeDriveContainer.appendChild(parkedInfo);

            panelEl = buildTransferPanel(v, true);
            financeDriveContainer.appendChild(makeTransferToggle(panelEl));
            vehicleItem.appendChild(financeDriveContainer);
        } else {
            const financeInfo = document.createElement("div");
            financeInfo.classList.add("finance-info");

            if (v.balance && v.balance > 0) {
                financeInfo.classList.add("status-financed");
                financeInfo.textContent = "FINANCED \u00B7 $" + v.balance.toFixed(0) + " left";
            } else {
                financeInfo.classList.add("status-bought");
                financeInfo.textContent = "BOUGHT";
            }

            financeDriveContainer.appendChild(financeInfo);

            const actions = document.createElement("div");
            actions.classList.add("btn-group");

            // Drive Button -- RME: in normal (non-depot) garages your stored cars
            // are always drivable. Only the dedicated depot/impound lot charges a
            // fee. This stops stale depotprice values leaving a dead button.
            let status;
            let isDepotPrice = false;

            if (v.type === "depot") {
                if (v.depotPrice && v.depotPrice > 0) {
                    isDepotPrice = true;
                    status = "$" + v.depotPrice.toFixed(0);
                } else {
                    status = "Drive";
                }
            } else if (v.state === 0) {
                status = "Out";
            } else if (v.state === 2) {
                status = "Impound";
            } else {
                status = "Drive";
            }

            // RME: allow gifting any stored, owned car (not depot, not out/impound).
            if (v.type !== "depot" && v.state === 1) {
                panelEl = buildTransferPanel(v, false);
                actions.appendChild(makeTransferToggle(panelEl));
            }

            const driveButton = document.createElement("button");
            driveButton.classList.add("drive-btn");
            driveButton.textContent = status;

            if (status === "Impound") {
                driveButton.classList.add("btn-muted");
                driveButton.disabled = true;
            }

            if (status === "Out") {
                driveButton.classList.add("btn-muted");
            }

            driveButton.onclick = function () {
                if (driveButton.disabled) return;

                const vehicleStats = {
                    fuel: v.fuel,
                    engine: v.engine,
                    body: v.body,
                };

                const vehicleData = {
                    vehicle: v.vehicle,
                    garage: v.garage,
                    index: v.index,
                    plate: v.plate,
                    type: v.type,
                    depotPrice: v.depotPrice,
                    stats: vehicleStats,
                };

                if (status === "Out") {
                    postNui("trackVehicle", v.plate).then((data) => {
                        if (data === "ok") closeGarageMenu();
                    });
                } else if (isDepotPrice) {
                    postNui("takeOutDepo", vehicleData).then((data) => {
                        if (data === "ok") closeGarageMenu();
                    });
                } else {
                    postNui("takeOutVehicle", vehicleData).then((data) => {
                        if (data === "ok") closeGarageMenu();
                    });
                }
            };

            actions.appendChild(driveButton);
            financeDriveContainer.appendChild(actions);
            vehicleItem.appendChild(financeDriveContainer);
        }

        // Progress Bars: Fuel, Engine, Body
        const stats = document.createElement("div");
        stats.classList.add("stats");

        const maxValues = {
            fuel: 100,
            engine: 1000,
            body: 1000,
        };

        ["fuel", "engine", "body"].forEach((statLabel) => {
            const stat = document.createElement("div");
            stat.classList.add("stat");
            const label = document.createElement("div");
            label.classList.add("label");
            label.textContent = statLabel.charAt(0).toUpperCase() + statLabel.slice(1);
            stat.appendChild(label);
            const progressBar = document.createElement("div");
            progressBar.classList.add("progress-bar");
            const progress = document.createElement("span");
            const progressText = document.createElement("span");
            progressText.classList.add("progress-text");
            const percentage = (v[statLabel] / maxValues[statLabel]) * 100;
            progress.style.width = percentage + "%";
            progressText.textContent = Math.round(percentage) + "%";

            if (percentage >= 75) {
                progress.classList.add("bar-green");
            } else if (percentage >= 50) {
                progress.classList.add("bar-yellow");
            } else {
                progress.classList.add("bar-red");
            }

            progressBar.appendChild(progressText);
            progressBar.appendChild(progress);
            stat.appendChild(progressBar);
            stats.appendChild(stat);
        });

        vehicleItem.appendChild(stats);

        // Transfer panel lives at the bottom of the card so it slides open
        // beneath the stats without shifting the action row.
        if (panelEl) vehicleItem.appendChild(panelEl);

        fragment.appendChild(vehicleItem);
    });

    vehicleContainerElem.appendChild(fragment);
}
