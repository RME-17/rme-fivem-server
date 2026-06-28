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

    fetch("https://qb-garages/closeGarage", {
        method: "POST",
        headers: {
            "Content-Type": "application/json; charset=UTF-8",
        },
        body: JSON.stringify({}),
    })
        .then((response) => response.json())
        .then((data) => {
            if (data === "ok") {
                return;
            } else {
                console.error("Failed to close Garage UI");
            }
        });
}

function displayUI() {
    const container = document.querySelector(".container");
    container.style.display = "block";
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

        // Ownership / Finance Info + action button
        const financeDriveContainer = document.createElement("div");
        financeDriveContainer.classList.add("finance-drive-container");

        if (v.transferable) {
            // Vehicle is stored at a different garage. Show where it is and offer
            // to transfer it into this garage for a flat fee.
            const parkedInfo = document.createElement("div");
            parkedInfo.classList.add("finance-info", "status-elsewhere");
            parkedInfo.textContent = "AT " + String(v.parkedLabel || "ANOTHER GARAGE").toUpperCase();
            financeDriveContainer.appendChild(parkedInfo);

            const transferButton = document.createElement("button");
            transferButton.classList.add("drive-btn", "btn-transfer");
            transferButton.textContent = "Transfer \u00B7 $200";
            transferButton.onclick = function () {
                if (transferButton.disabled) return;
                transferButton.disabled = true;
                transferButton.textContent = "Transferring...";
                fetch("https://qb-garages/transferVehicle", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json; charset=UTF-8",
                    },
                    body: JSON.stringify({ plate: v.plate, index: v.index }),
                })
                    .then((response) => response.json())
                    .catch(() => {});
            };
            financeDriveContainer.appendChild(transferButton);
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
                    fetch("https://qb-garages/trackVehicle", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json; charset=UTF-8",
                        },
                        body: JSON.stringify(v.plate),
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            if (data === "ok") {
                                closeGarageMenu();
                            } else {
                                return;
                            }
                        });
                } else if (isDepotPrice) {
                    fetch("https://qb-garages/takeOutDepo", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json; charset=UTF-8",
                        },
                        body: JSON.stringify(vehicleData),
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            if (data === "ok") {
                                closeGarageMenu();
                            } else {
                                console.error("Failed to pay depot price.");
                            }
                        });
                } else {
                    fetch("https://qb-garages/takeOutVehicle", {
                        method: "POST",
                        headers: {
                            "Content-Type": "application/json; charset=UTF-8",
                        },
                        body: JSON.stringify(vehicleData),
                    })
                        .then((response) => response.json())
                        .then((data) => {
                            if (data === "ok") {
                                closeGarageMenu();
                            } else {
                                console.error("Failed to close Garage UI.");
                            }
                        });
                }
            };

            financeDriveContainer.appendChild(driveButton);
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
            vehicleItem.appendChild(stats);
        });

        fragment.appendChild(vehicleItem);
    });

    vehicleContainerElem.appendChild(fragment);
}
